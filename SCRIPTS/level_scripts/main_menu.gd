extends Control

@onready var space_sprite: Sprite2D = $Background/SpaceSprite
@onready var ship_sprite: Sprite2D = $Background/ShipSprite
@onready var title: VBoxContainer = $CanvasLayer/Title
@onready var options_menu: VBoxContainer = $CanvasLayer/OptionsMenu
@onready var left_menu: VBoxContainer = $CanvasLayer/Left/LeftMenu
@onready var right_menu: VBoxContainer = $CanvasLayer/Right/RightMenu
@onready var tooltip_button: Button = $CanvasLayer/OptionsMenu/TooltipButton
@onready var master_scroll: HScrollBar = $CanvasLayer/OptionsMenu/Master_Scroll
@onready var music_scroll: HScrollBar = $CanvasLayer/OptionsMenu/Music_Scroll
@onready var sfx_scroll: HScrollBar = $CanvasLayer/OptionsMenu/SFX_Scroll


var tween: Tween
var r_options_openned: bool = false
var l_options_openned: bool = false
var animations_ended: bool = false

func _ready() -> void:
	 # Shader blink
	space_sprite.material.set_shader_parameter("active", true)
	 # Set volumes and scrollers
	var value: float = Events.master_volume
	AudioServer.set_bus_volume_db(0, linear_to_db(value)); master_scroll.value = value
	value = Events.music_volume
	AudioServer.set_bus_volume_db(1, linear_to_db(value)); music_scroll.value = value
	value = Events.sfx_volume
	AudioServer.set_bus_volume_db(2, linear_to_db(value)); sfx_scroll.value = value
	 # Play Music
	AudioManager.play_mus("space_music")
	 # Tooltip Button Correction
	if Events.tooltips:
		tooltip_button.button_pressed = true
		tooltip_button.text = "Tooltip ON"
	 # Animate spaceship
	fade_in(Color("ffffff96")); zoom_in(Vector2(640,2936)); scale_in(Vector2(340,340))
	await get_tree().create_timer(1.8).timeout
	 # Animate title
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(title, "position", Vector2(456, 54), 2)
	await get_tree().create_timer(0.5).timeout
	animations_ended = true


# Animate Ship Zooming in /out
func fade_in(col: Color) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	tween.tween_property(ship_sprite, "modulate", col, 2)
func zoom_in(pos: Vector2) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	tween.tween_property(ship_sprite, "position", pos, 2)
func scale_in(scal: Vector2) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	tween.tween_property(ship_sprite, "scale", scal, 2)


 # Menu Animations
func _on_left_mouse_entered() -> void:
	if animations_ended and not l_options_openned:
		animate_left_menu(Vector2(69, 230.5))
		if not r_options_openned:
			AudioManager.play_sfx("menu_slide")

func _on_left_mouse_exited() -> void:
	if animations_ended and not r_options_openned:
		animate_left_menu(Vector2(-300, 230.5))

func _on_right_mouse_entered() -> void:
	if animations_ended and not r_options_openned:
		animate_right_menu(Vector2(317, 230.5))
		if not l_options_openned:
			AudioManager.play_sfx("menu_slide")

func _on_right_mouse_exited() -> void:
	if animations_ended and not l_options_openned:
		animate_right_menu(Vector2(686, 230.5))

func animate_right_menu(pos: Vector2) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(right_menu, "position", pos, 0.5)

func animate_left_menu(pos: Vector2) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(left_menu, "position", pos, 0.5)


 # Options Menu Animations
func _on_left_options_pressed() -> void:
	if r_options_openned:
		animate_left_options(Vector2(1350, 170))
		r_options_openned = false
	else:
		options_menu.position = Vector2(1350, 160)
		animate_left_options(Vector2(950, 170))
		r_options_openned = true
	AudioManager.play_sfx("button_clicked")

func _on_right_options_pressed() -> void:
	if l_options_openned:
		animate_right_options(Vector2(-322, 170))
		l_options_openned = false
	else:
		options_menu.position = Vector2(-322, 170);
		animate_right_options(Vector2(122, 170))
		l_options_openned = true
	AudioManager.play_sfx("button_clicked")

func animate_right_options(pos: Vector2) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(options_menu, "position",pos, 0.5)

func animate_left_options(pos: Vector2) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(options_menu, "position", pos, 0.5)


func hide_everything() -> void:
	animate_left_menu(Vector2(-300, 230.5))
	animate_right_menu(Vector2(686, 230.5))
	if r_options_openned:
		animate_left_options(Vector2(1350, 170))
	elif l_options_openned:
		animate_right_options(Vector2(-322, 170))
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_IN)
	tween.tween_property(title, "position", Vector2(456, -175), 2)


func _on_play_pressed() -> void:
	hide_everything(); animations_ended = false
	AudioManager.play_sfx("button_clicked")
	await get_tree().create_timer(0.5).timeout
	
	fade_in(Color.WHITE); zoom_in(Vector2(640,430)); scale_in(Vector2(2,2))
	await get_tree().create_timer(2).timeout
	
	get_tree().change_scene_to_file("res://SCENES/levels/game.tscn")

func _on_tooltip_button_pressed() -> void:
	if Events.tooltips:
		Events.tooltips = false
		tooltip_button.text = "Tooltip OFF"
	else:
		Events.tooltips = true
		tooltip_button.text = "Tooltip ON"
	AudioManager.play_sfx("button_clicked")

func _on_quit_pressed() -> void:
	get_tree().quit()



func _on_master_scroll_value_changed(value: float) -> void:
	master_scroll.value = value
	Events.master_volume = value
	AudioServer.set_bus_volume_db(0, linear_to_db(value))

func _on_music_scroll_value_changed(value: float) -> void:
	music_scroll.value = value
	Events.music_volume = value
	AudioServer.set_bus_volume_db(1, linear_to_db(value))

func _on_sfx_scroll_value_changed(value: float) -> void:
	sfx_scroll.value = value
	Events.sfx_volume = value
	AudioServer.set_bus_volume_db(2, linear_to_db(value))
	AudioManager.play_menu_sfx()
