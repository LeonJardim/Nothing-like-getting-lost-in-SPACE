class_name Stats
extends Resource

signal stats_changed

@export var max_health: int = 1
@export var starting_shield: int
@export var art: Texture

var health: int: set = set_health
var shield: int: set = set_shield

func set_health(value: int) -> void:
	health = clampi(value, 0, max_health)
	stats_changed.emit()

func set_shield(value: int) -> void:
	shield = clampi(value, 0, 99)
	stats_changed.emit()

func take_damage(damage: int) -> void:
	if damage <= 0:
		return
	var initial_damage = damage
	damage = clampi(damage - shield, 0, damage)
	self.shield = clampi(shield - initial_damage, 0, shield)
	self.health -= damage
	
func heal(amount: int) -> void:
	self.health += amount

# Create Instance for enemy
func create_instance() -> Resource:
	var instance: Stats = self.duplicate()
	instance.health = max_health
	instance.shield = starting_shield
	return instance
