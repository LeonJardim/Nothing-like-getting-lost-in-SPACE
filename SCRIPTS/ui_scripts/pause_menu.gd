class_name PauseMenu
extends Panel

@onready var buttons: VBoxContainer = $Buttons
@onready var scrollers: VBoxContainer = $Scrollers
@onready var master_scroll: HScrollBar = $Scrollers/MasterScroll
@onready var music_scroll: HScrollBar = $Scrollers/MusicScroll
@onready var sfx_scroll: HScrollBar = $Scrollers/EffectsScroll
@onready var tooltip_button: Button = $Buttons/TooltipButton
@onready var pause_button: Button = $PauseButton


var game_paused:bool = false
var tween: Tween


func _ready() -> void:
	var value: float = Events.master_volume
	AudioServer.set_bus_volume_db(0, linear_to_db(value)); master_scroll.value = value
	value = Events.music_volume
	AudioServer.set_bus_volume_db(1, linear_to_db(value)); music_scroll.value = value
	value = Events.sfx_volume
	AudioServer.set_bus_volume_db(2, linear_to_db(value)); sfx_scroll.value = value
	 # Tooltip Button Correction
	if Events.tooltips:
		tooltip_button.button_pressed = true
		tooltip_button.text = "Tooltip ON"
	
	await get_tree().create_timer(1).timeout
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(pause_button, "position", Vector2(1210, 653), 1)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("pause") and game_paused:
		_resume()
	elif event.is_action_pressed("pause") and not game_paused:
		_pause()


func _pause() -> void:
	game_paused = true; mouse_filter = Control.MOUSE_FILTER_STOP
	get_tree().paused = true
	 # Panel Show
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self.get_theme_stylebox("panel"), "bg_color", Color("d7d7d7b4"), 0.5)
	 # Buttons Show
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(buttons, "position", Vector2(980,218.5), 0.5)
	 # Scrollers Show
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(scrollers, "position", Vector2(73,207), 0.5)

func _resume() -> void:
	game_paused = false; mouse_filter = Control.MOUSE_FILTER_IGNORE
	get_tree().paused = false
	 # Panel Hide
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self.get_theme_stylebox("panel"), "bg_color", Color("d7d7d700"), 0.5)
	 # Buttons Hide
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(buttons, "position", Vector2(1380,218.5), 0.5)
	 # Scrollers Hide
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(scrollers, "position", Vector2(-373,207), 0.5)


func _on_resume_button_pressed() -> void:
	_resume()
	AudioManager.play_sfx("button_clicked")

func _on_tooltip_button_pressed() -> void:
	if Events.tooltips:
		Events.tooltips = false
		tooltip_button.text = "Tooltip OFF"
	else:
		Events.tooltips = true
		tooltip_button.text = "Tooltip ON"
	AudioManager.play_sfx("button_clicked")

func _on_quit_button_pressed() -> void:
	_resume()
	AudioManager.play_sfx("button_clicked")
	await get_tree().create_timer(0.5).timeout
	get_tree().change_scene_to_file("res://SCENES/levels/main_menu.tscn")


func _on_pause_button_pressed() -> void:
	AudioManager.play_sfx("button_clicked")
	if game_paused:
		_resume()
	else:
		_pause()


func _on_master_scroll_value_changed(value: float) -> void:
	master_scroll.value = value
	Events.master_volume = value
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

func _on_music_scroll_value_changed(value: float) -> void:
	music_scroll.value = value
	Events.music_volume = value
	AudioServer.set_bus_volume_db(1, linear_to_db(value))

func _on_effects_scroll_value_changed(value: float) -> void:
	sfx_scroll.value = value
	Events.sfx_volume = value
	AudioServer.set_bus_volume_db(2, linear_to_db(value))
	AudioManager.play_menu_sfx()
