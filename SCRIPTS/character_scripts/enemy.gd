class_name Enemy
extends Area2D

@export var stats: Stats: set = set_enemy_stats

@onready var select_color: Panel = $SelectColor
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D
@onready var explosion_sprite: AnimatedSprite2D = $ExplosionSprite
@onready var stats_ui: StatsUI = $StatsUI as StatsUI

var mov_direction: Vector2 = Vector2.RIGHT
var mov_speed: int = 100
var direction_to_shoot: Vector2 = Vector2.DOWN
var player: Player
var is_shooting: bool = false
var is_escaping: bool = false
var alien_ray := preload("res://SCENES/projectiles/alien_ray.tscn")

func _ready() -> void:
	Events.game_finished.connect(_escape)
	
	player = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	if is_escaping:
		return
	if not is_shooting:
		position += mov_direction * mov_speed * delta
		if position.x > 1156 and mov_direction == Vector2.RIGHT:
			mov_direction = Vector2.LEFT
		elif position.x < 124 and mov_direction == Vector2.LEFT:
			mov_direction = Vector2.RIGHT


func set_enemy_stats(value: Stats) -> void:
	stats = value.create_instance()
	
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	
	update_enemy()

func update_stats() -> void:
	stats_ui.update_stats(stats)

func update_enemy() -> void:
	if not stats is Stats:
		return
	if not is_inside_tree():
		await ready
	
	#sprite_2d.texture = stats.art
	update_stats()


func shot() -> void:
	if (not player) or (is_escaping):
		return
	is_shooting = true
	animated_sprite_2d.play("shooting")
	await get_tree().create_timer(1).timeout
	 # Instantiate Laser Ray
	direction_to_shoot = (player.global_position - global_position).normalized()
	var instance = alien_ray.instantiate()
	instance.global_position = global_position
	instance.target_direction = direction_to_shoot
	get_parent().add_child(instance)
	 # Play SFX
	AudioManager.play_sfx("alien_laser")
	
	await get_tree().create_timer(1).timeout
	animated_sprite_2d.play("idle")
	is_shooting = false

func _escape() -> void:
	is_escaping = true
	var where_to: Vector2
	where_to.y = position.y
	if position.x >= 640:
		where_to.x = 1350
	else:
		where_to.x = -120
	
	var tween: Tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", where_to, 2)


func take_damage(damage: int) -> void:
	if stats.health <= 0:
		return
	
	self.animated_sprite_2d.modulate = Color.CRIMSON
	
	var tween: Tween = create_tween()
	tween.tween_callback(Shaker.shake.bind(self, 32))
	tween.tween_callback(stats.take_damage.bind(damage))
	tween.tween_interval(0.2)
	
	tween.finished.connect(
		func():
			self.animated_sprite_2d.modulate = Color.WHITE
			if stats.health <= 0:
				player.stats.reset_energy()
				AudioManager.play_sfx("explosion")
				animated_sprite_2d.visible = false; stats_ui.visible = false
				explosion_sprite.visible = true; explosion_sprite.play("explode")
				await get_tree().create_timer(1).timeout
				Events.is_there_an_enemy = false
				queue_free()
			else:
				AudioManager.play_sfx("enemy_hurt")
	)


func _on_area_entered(area: Area2D) -> void:
	if not area is Asteroid:
		select_color.show()

func _on_area_exited(area: Area2D) -> void:
	if not area is Asteroid:
		select_color.hide()


func _on_attack_timer_timeout() -> void:
	shot()
