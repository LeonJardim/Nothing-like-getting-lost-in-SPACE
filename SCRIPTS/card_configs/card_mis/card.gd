class_name Card
extends Resource

enum Type { ATTACK, SKILL, POWER}
enum Target { SELF, SINGLE_ENEMY, ALL_ENEMIES, EVERYONE}

@export_group("Card Atributes")
@export var id: String
@export var type: Type
@export var target: Target
@export var cost: int

@export_group("Card Visuals")
@export var texture: Texture
@export var icon: Texture
@export var target_icon: Texture
@export_multiline var tooltip_text: String

func is_single_targeted() -> bool:
	return target == Target.SINGLE_ENEMY


func _get_targets(targets: Array[Node]) -> Array[Node]:
	if not targets:
		return []
	
	var tree: = targets[0].get_tree()
	var tree_player = tree.get_nodes_in_group("player")
	var tree_enemies = tree.get_nodes_in_group("enemies")
	var tree_asteroids = tree.get_nodes_in_group("asteroids")
	
	match target:
		Target.SELF:
			return tree_player
		Target.ALL_ENEMIES:
			return tree_enemies + tree_asteroids
		Target.EVERYONE:
			return tree_player + tree_enemies + tree_asteroids
		_:
			return []


func play(targets: Array[Node], char_stats: CharacterStats) -> void:
	Events.card_played.emit(self)
	char_stats.energy -= cost
	 
	if is_single_targeted():
		apply_effects(targets)
	else:
		apply_effects(_get_targets(targets))

func apply_effects(_targets: Array[Node]) -> void:
	pass
