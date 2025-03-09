class_name Spawner
extends Path2D

@onready var path_follow: PathFollow2D = $PathFollow # Spawns From Above
@onready var marker: Marker2D = $Marker # Spawns From Sides
@onready var rock_spawn_ratio: Timer = $RockSpawnRatio
@onready var enemy_spawn_ratio: Timer = $EnemySpawnRatio


const ASTEROID := preload("res://SCENES/objects/asteroid.tscn")
const ALIEN := preload("res://SCENES/characters/enemy.tscn")

func _ready() -> void:
	rock_spawn_ratio.start(10)


func spawn_asteroid() -> void:
	var point_to_spawn: float = randf()
	path_follow.progress_ratio = point_to_spawn
	var instance = ASTEROID.instantiate()
	instance.global_position = path_follow.position;
	add_child(instance)

func spawn_enemy() -> void:
	var spawn_spot: Vector2
	var odd: int = randi_range(1,6)
	match odd:
		1: spawn_spot = marker.position + Vector2(0,-120)
		2: spawn_spot = marker.position
		3: spawn_spot = marker.position + Vector2(0,120)
		4: spawn_spot = marker.position + Vector2(1440,-120)
		5: spawn_spot = marker.position + Vector2(1440,0)
		6: spawn_spot = marker.position + Vector2(1440,120)
	
	var instance := ALIEN.instantiate()
	instance.global_position = spawn_spot
	add_child(instance)


func _on_rock_spawn_ratio_timeout() -> void:
	spawn_asteroid()

func _on_enemy_spawn_ratio_timeout() -> void:
	if not Events.is_there_an_enemy:
		for i in range(Events.enemy_amount_difficulty):
			spawn_enemy()
			await get_tree().create_timer(0.8).timeout
