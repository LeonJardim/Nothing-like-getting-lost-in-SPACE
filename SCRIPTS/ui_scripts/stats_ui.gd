class_name StatsUI
extends HBoxContainer

@onready var health: HBoxContainer = $Health
@onready var health_label: Label = %HealthLabel
@onready var shield: HBoxContainer = $Shield
@onready var shield_label: Label = %ShieldLabel

var tween: Tween

func _ready() -> void:
	Events.game_finished.connect(_fade_out)
	
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"modulate", Color.WHITE, 2)

func update_stats(stats: Stats) -> void:
	shield_label.text = str(stats.shield)
	health_label.text = str(stats.health)


func _fade_out() -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self,"modulate", Color(1,1,1,0), 2)
