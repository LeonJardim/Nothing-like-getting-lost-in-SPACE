class_name Asteroid
extends Area2D

@export var ast1: Texture
@export var ast2: Texture
@export var ast3: Texture
@export var ast4: Texture

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape
@onready var selector_panel: Panel = $SelectorPanel

var mov_speed: int = 80
var rot_speed: float = 0.7

func _ready() -> void:
	Events.game_finished.connect(_hide)
	
	set_my_shape()
	set_my_movement()

 # Disapear if out of screen
func _process(_delta: float) -> void:
	if global_position.y >= 740:
		queue_free()

 # Movement / Rotation
func _physics_process(delta: float) -> void:
	position += Vector2(0,1) * mov_speed * delta
	rotation += rot_speed * delta


func set_my_shape() -> void:
	var odd = randi_range(1,4)
	var new_rec: RectangleShape2D = RectangleShape2D.new()
	match odd:
		1: sprite_2d.texture = ast1; new_rec.size = Vector2(12,14); collision_shape.shape = new_rec
		2: sprite_2d.texture = ast2; new_rec.size = Vector2(14,12); collision_shape.shape = new_rec
		3: sprite_2d.texture = ast3; new_rec.size = Vector2(16,16); collision_shape.shape = new_rec
		4: sprite_2d.texture = ast4; new_rec.size = Vector2(16,14); collision_shape.shape = new_rec

func set_my_movement() -> void:
	var odd1: float = randi_range(6, 11)
	odd1 = odd1 / 10
	var odd2: int = randi_range(0,1)
	var odd3: int = randi_range(60,100)
	match odd2:
		0: rot_speed = odd1
		1: rot_speed = -odd1
	mov_speed = odd3

func _hide() -> void:
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "modulate", Color(1,1,1,0), 1)


func _on_area_entered(area: Area2D) -> void:
	if (area is Player) or (area is Enemy):
		area.take_damage(10)
		AudioManager.play_sfx("asteroid_destroyed")
		queue_free()
	elif area is EnemyProjectile:
		area.queue_free()
		AudioManager.play_sfx("asteroid_destroyed")
		queue_free()
	else:
		selector_panel.show()

func _on_area_exited(_area: Area2D) -> void:
	selector_panel.hide()
