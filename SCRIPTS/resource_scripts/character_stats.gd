class_name CharacterStats
extends Stats

@export var starting_deck: CardPile
@export var hand_size: int
@export var max_energy: int

var energy: int: set = set_energy

var deck: CardPile
var discard: CardPile
var draw_pile: CardPile

func set_energy(value: int) -> void:
	energy = value
	stats_changed.emit()

func add_energy(value: int) -> void:
	if energy + value >= max_energy:
		energy = max_energy
	else:
		energy += value

func reset_energy() -> void:
	self.energy = max_energy

func can_play_card(card: Card) -> bool:
	return energy >= card.cost

# Create instance for player
func create_instance() -> Resource:
	var instance: CharacterStats = self.duplicate()
	instance.health = max_health
	instance.shield = starting_shield
	instance.reset_energy()
	instance.deck = instance.starting_deck.duplicate()
	instance.draw_pile = CardPile.new()
	instance.discard = CardPile.new()
	return instance
