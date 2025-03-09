extends Node

 # Card-Related Events
signal card_drag_started(card_ui: CardUI)
signal card_drag_ended(card_ui: CardUI)
signal card_aim_started(card_ui: CardUI)
signal card_aim_ended(card_ui: CardUI)
signal card_played(card: Card)
signal card_tooltip_requested(card: Card)
signal tooltip_hide_requested

 # Player-Related Events
signal card_draw_requested(amount: int)
signal card_back_to_draw_pile_requested(card: Card)
signal player_started_dodging(target: Node2D, duration: int)

 # Game-Related Events
signal game_finished

 # Global Variables
var tooltips: bool = true
var enemy_amount_difficulty: int = 1
var is_there_an_enemy: bool = false
var master_volume: float = 0.7
var music_volume: float = 0.3
var sfx_volume: float = 1
