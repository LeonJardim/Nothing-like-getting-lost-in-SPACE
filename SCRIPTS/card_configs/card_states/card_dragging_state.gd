extends CardState

const DRAG_MINIMUN_TRESHOLD: float = 0.05
var minimun_drag_time_enlapsed: bool = false

func enter() -> void:
	# Reparent to move freely
	var ui_layer:= get_tree().get_first_node_in_group("ui_layer")
	if ui_layer:
		card_ui.reparent(ui_layer)
	
	Events.card_drag_started.emit(card_ui)
	
	# Avoid double click Bug
	minimun_drag_time_enlapsed = false
	var treshold_timer: = get_tree().create_timer(DRAG_MINIMUN_TRESHOLD, false)
	treshold_timer.timeout.connect(func(): minimun_drag_time_enlapsed = true)
	
	card_ui.dragging_color.show()


func exit() -> void:
	Events.card_drag_ended.emit(card_ui)


func on_input(event: InputEvent) -> void:
	var single_targeted:= card_ui.card.is_single_targeted()
	var mouse_motion:= event is InputEventMouseMotion
	var cancel = event.is_action_pressed("right_mouse")
	var confirm = event.is_action_released("left_mouse") or event.is_action_pressed("left_mouse")
	
	if single_targeted and mouse_motion and card_ui.targets.size() > 0:
		transition_requested.emit(self, CardState.State.AIMING)
		return
	
	if mouse_motion:
		card_ui.global_position = card_ui.get_global_mouse_position() - card_ui.pivot_offset
		if card_ui.get_global_mouse_position().y > 680:
			transition_requested.emit(self, CardState.State.BASE)
	
	if cancel:
		transition_requested.emit(self, CardState.State.BASE)
	
	elif minimun_drag_time_enlapsed and confirm:
		get_viewport().set_input_as_handled()
		transition_requested.emit(self, CardState.State.RELEASED)
