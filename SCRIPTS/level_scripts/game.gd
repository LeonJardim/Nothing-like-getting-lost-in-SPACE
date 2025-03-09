extends Node2D

@export var char_stats: CharacterStats: set = _set_char_stats

@onready var battle_ui: BattleUI = $BattleUI as BattleUI
@onready var player_handler: PlayerHandler = $PlayerHandler as PlayerHandler
@onready var space_background: Sprite2D = $Utilities/SpaceBackground
@onready var player: Player = $Player as Player


func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value

func _ready() -> void:
	Events.player_started_dodging.connect(_stop_dodging)
	
	space_background.material.set_shader_parameter("active", true)
	
	var new_stats: CharacterStats = char_stats.create_instance()
	battle_ui.char_stats = new_stats
	player.stats = new_stats
	
	start_battle(new_stats)


func _process(_delta: float) -> void:
	if not Events.is_there_an_enemy:
		if get_tree().get_first_node_in_group("enemies"):
			Events.is_there_an_enemy = true


func start_battle(stats: CharacterStats) -> void:
	player_handler.start_battle(stats)


func _stop_dodging(target: Node2D, duration: int) -> void:
	await get_tree().create_timer(duration).timeout
	target.collision.disabled = false
	target.deactivate_dodge_visual()
