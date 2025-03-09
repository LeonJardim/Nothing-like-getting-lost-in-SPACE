class_name EnemyProjectile
extends Area2D

const SPEED: int = 150
var target_direction: Vector2 = Vector2.DOWN
var is_game_finished: bool = false

func _ready() -> void:
	Events.game_finished.connect(_end_disapear)
	rotation = target_direction.angle()

func _physics_process(delta: float) -> void:
	if is_game_finished:
		queue_free()
	position += target_direction * SPEED * delta


func _on_area_entered(area: Area2D) -> void:
	if area is Player:
		area.take_damage(7)
		queue_free()

func _end_disapear() -> void:
	is_game_finished = true
