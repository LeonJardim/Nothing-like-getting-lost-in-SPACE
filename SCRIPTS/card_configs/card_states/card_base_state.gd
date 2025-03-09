extends CardState

func enter() -> void:
	if not card_ui.is_node_ready():
		await card_ui.ready
	
	if card_ui.tween and card_ui.tween.is_running():
		card_ui.tween.kill()
	 # Card Back to Hand
	card_ui.reparenting_request.emit(card_ui)
	card_ui.pivot_offset = Vector2.ZERO
	 # Card Visuals
	card_ui.feedback_color.hide()
	card_ui.black_panel.show()
	card_ui.dragging_color.hide()
	 # Tooltip hide
	Events.tooltip_hide_requested.emit()

func on_gui_input(event: InputEvent) -> void:
	if (event.is_action_pressed("left_mouse")) and ((not card_ui.playable) or (card_ui.disabled)):
		AudioManager.play_sfx("card_unplayable")
		return
	if event.is_action_pressed("left_mouse"):
		card_ui.pivot_offset = card_ui.get_global_mouse_position() - card_ui.global_position
		transition_requested.emit(self, CardState.State.CLICKED)

func on_mouse_entered() -> void:
	 # Show Tooltips
	if Events.tooltips:
		Events.card_tooltip_requested.emit(str(card_ui.card.cost), card_ui.card.icon, card_ui.card.tooltip_text,
		card_ui.card.target_icon, card_ui.card.target)
	 # Select Feedback
	var can_play_hover_sfx: bool = true
	if not card_ui.playable or card_ui.disabled:
		card_ui.feedback_color.get("theme_override_styles/panel").bg_color = Color("ff3333ba")
		can_play_hover_sfx = false
	card_ui.feedback_color.show()
	card_ui.black_panel.hide()
	
	if can_play_hover_sfx:
		AudioManager.play_sfx("card_hover")


func on_mouse_exited() -> void:
	if not card_ui.playable or card_ui.disabled:
		card_ui.feedback_color.get("theme_override_styles/panel").bg_color = Color("6edbffba")
	card_ui.feedback_color.hide()
	card_ui.black_panel.show()
	
	Events.tooltip_hide_requested.emit()
