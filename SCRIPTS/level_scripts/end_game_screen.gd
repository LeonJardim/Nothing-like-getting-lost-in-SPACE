extends Control

@onready var space_sprite: Sprite2D = $Space
@onready var planet: Sprite2D = $Planet
@onready var ship: Sprite2D = $Ship
@onready var you_arrived: Label = $YouArrived
@onready var thanks: Label = $Thanks
@onready var return_button: Button = $ReturnButton

var tween: Tween


func _ready() -> void:
	space_sprite.material.set_shader_parameter("active", true)
	
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(planet, "position", Vector2(640,360), 4)
	
	ship_arrive()

func ship_arrive() -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(ship, "position", Vector2(640,360), 6)
	await get_tree().create_timer(2).timeout
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(ship, "scale", Vector2(0.001,0.001), 4)
	await get_tree().create_timer(4).timeout
	ship.queue_free()
	animate_end_text()

func animate_end_text() -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(you_arrived, "position", Vector2(66,223), 1)
	
	await get_tree().create_timer(2).timeout
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(thanks, "position", Vector2(66,396), 1)
	
	await get_tree().create_timer(2).timeout
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(return_button, "position", Vector2(819,327.5), 1)


func _on_return_button_pressed() -> void:
	AudioManager.play_sfx("button_clicked")
	get_tree().change_scene_to_file("res://SCENES/levels/main_menu.tscn")
