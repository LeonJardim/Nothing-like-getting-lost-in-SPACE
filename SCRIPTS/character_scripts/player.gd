class_name Player
extends Area2D

@export var stats: CharacterStats: set = set_character_stats

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var explosion_sprite: AnimatedSprite2D = $ExplosionSprite
@onready var collision: CollisionPolygon2D = $Collision
@onready var stats_ui: StatsUI = $StatsUI as StatsUI


func set_character_stats(value: CharacterStats) -> void:
	stats = value
	if not stats.stats_changed.is_connected(update_stats):
		stats.stats_changed.connect(update_stats)
	
	update_player()


func update_player() -> void:
	if not stats is CharacterStats:
		return
	if not is_inside_tree():
		await ready
	
	sprite_2d.texture = stats.art
	update_stats()


func update_stats() -> void:
	stats_ui.update_stats(stats)


func _ready() -> void:
	Events.game_finished.connect(_end_invincibility)

func take_damage(damage: int) -> void:
	if stats.health <= 0:
		return
	
	self.sprite_2d.modulate = Color.CRIMSON
	
	var tween: Tween = create_tween()
	tween.tween_callback(Shaker.shake.bind(self, 32))
	tween.tween_callback(stats.take_damage.bind(damage))
	tween.tween_interval(0.2)
	
	tween.finished.connect(
		func():
			self.sprite_2d.modulate = Color.WHITE
			if stats.health <= 0:
				AudioManager.play_sfx("explosion")
				sprite_2d.visible = false; stats_ui.visible = false
				explosion_sprite.visible = true; explosion_sprite.play("explode")
				await get_tree().create_timer(1).timeout
				queue_free()
			else:
				AudioManager.play_sfx("hurt")
	)


func _end_invincibility() -> void:
	collision.disabled = true

func activate_dodge_visual() -> void:
	sprite_2d.material.set_shader_parameter("ship_dodge", true)

func deactivate_dodge_visual() -> void:
	sprite_2d.material.set_shader_parameter("ship_dodge", false)


func _on_explosion_sprite_animation_finished() -> void:
	sprite_2d.visible = true
	get_tree().change_scene_to_file("res://SCENES/levels/main_menu.tscn")
