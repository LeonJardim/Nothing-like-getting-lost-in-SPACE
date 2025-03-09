class_name EnergyUI
extends Panel

@export var char_stats: CharacterStats: set = _set_char_stats

@onready var text: Label = $HBoxContainer/Text

const BLACK_ENERGY_PANEL = preload("res://RESOURCES/UI_RESOURCES/black_energy_panel.tres")
const GREEN_ENERGY_PANEL = preload("res://RESOURCES/UI_RESOURCES/green_energy_panel.tres")
var first_update: bool = false
var tween: Tween

func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	
	if not char_stats.stats_changed.is_connected(_on_stats_changed):
		char_stats.stats_changed.connect(_on_stats_changed)
	
	if not is_node_ready():
		await ready
	
	_on_stats_changed()

func _on_stats_changed() -> void:
	text.text = "%s/%s" % [char_stats.energy, char_stats.max_energy]
	if not first_update:
		first_update = true
		return
	if char_stats.energy == char_stats.max_energy:
		add_theme_stylebox_override("panel", GREEN_ENERGY_PANEL)
		await get_tree().create_timer(1).timeout
		add_theme_stylebox_override("panel", BLACK_ENERGY_PANEL)

func _ready() -> void:
	await get_tree().create_timer(1).timeout
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", Vector2(50, 570), 1)
