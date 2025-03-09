class_name BattleUI
extends CanvasLayer

@export var char_stats: CharacterStats: set = _set_char_stats

@onready var hand: Hand = $Hand as Hand
@onready var energy_ui: EnergyUI = $EnergyUI as EnergyUI
@onready var pause_button: Button = $PauseMenu/PauseButton
@onready var progress_bar: ProgressBar = $ProgressBar

var tween: Tween

func _ready() -> void:
	Events.game_finished.connect(_finish_game)


func _finish_game() -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(hand, "position", Vector2(358, 800), 2)
	
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(energy_ui, "position", Vector2(-250, 570), 2)
	
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(pause_button, "position", Vector2(1300, 653), 2)
	
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(progress_bar, "position", Vector2(360, -49), 2)
	
	AudioManager.play_sfx("victory")
	
	await get_tree().create_timer(2.2).timeout
	get_tree().change_scene_to_file("res://SCENES/levels/end_game_screen.tscn")

func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	energy_ui.char_stats = char_stats
	hand.char_stats = char_stats
