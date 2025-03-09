class_name Hand
extends HBoxContainer

@export var char_stats: CharacterStats

@onready var card_ui := preload("res://SCENES/cards/card_ui.tscn")

var tween: Tween

func _ready() -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", Vector2(358,540), 1)

func add_card(card: Card) -> void:
	var new_card_ui := card_ui.instantiate()
	add_child(new_card_ui)
	new_card_ui.reparenting_request.connect(_on_card_ui_reparenting_requested)
	new_card_ui.card = card
	new_card_ui.parent = self
	new_card_ui.char_stats = char_stats


func _on_card_ui_reparenting_requested(child: CardUI) -> void:
	#child.disabled = true
	child.reparent(self)
	var new_index := clampi(child.original_index, 0, get_child_count())
	move_child.call_deferred(child, new_index)
	#child.call_deferred("disabled", false)
