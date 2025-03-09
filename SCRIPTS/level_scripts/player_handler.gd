class_name PlayerHandler
extends Node

const HAND_DRAW_INTERVAL: float = 0.4

@export var hand: Hand

var character: CharacterStats

func _ready() -> void:
	Events.card_draw_requested.connect(draw_cards)
	Events.card_back_to_draw_pile_requested.connect(_return_to_pile)

func start_battle(char_stats: CharacterStats) -> void:
	character = char_stats
	character.draw_pile = character.deck.duplicate(true)
	character.draw_pile.shuffle()
	character.discard = CardPile.new()
	await get_tree().create_timer(0.3).timeout
	start_turn()

func start_turn() -> void:
	draw_cards(character.hand_size)

func draw_card() -> void:
	if character.draw_pile.empty():
		return
	character.draw_pile.shuffle()
	hand.add_card(character.draw_pile.draw_card())
	for _card_ui in hand.get_children():
		if _card_ui is CardUI and _card_ui.char_stats:
			_card_ui.playable = _card_ui.char_stats.can_play_card(_card_ui.card)
	AudioManager.play_sfx("card_draw")

func draw_cards(amount: int) -> void:
	var tween: Tween = create_tween()
	for i in range(amount):
		tween.tween_callback(draw_card)
		tween.tween_interval(HAND_DRAW_INTERVAL)


func _return_to_pile(card: Card) -> void:
	character.draw_pile.add_card(card)
