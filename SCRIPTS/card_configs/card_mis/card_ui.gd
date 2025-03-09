class_name CardUI
extends Control

signal reparenting_request(wich_card_ui: CardUI)

@export var card: Card: set = _set_card
@export var char_stats: CharacterStats: set = _set_char_stats

@onready var texture: TextureRect = $Texture
@onready var feedback_color: Panel = $FeedbackColor
@onready var dragging_color: Panel = $DraggingColor
@onready var black_panel: Panel = $BlackPanel

@onready var drop_point_detector: Area2D = $DropPointDetector
@onready var card_state_machine: CardStateMachine = $CardStateMachine as CardStateMachine
@onready var targets: Array[Node] = []

var original_index: int = 0
var parent: Control
var tween: Tween
var playable: bool = true: set = _set_playable
var disabled: bool = false

func _ready() -> void:
	Events.card_aim_started.connect(_on_card_drag_or_aim_started)
	Events.card_drag_started.connect(_on_card_drag_or_aim_started)
	Events.card_drag_ended.connect(_on_card_drag_or_aim_ended)
	Events.card_aim_ended.connect(_on_card_drag_or_aim_ended)
	card_state_machine.init(self)

func _input(event: InputEvent) -> void:
	card_state_machine.on_input(event)

func _on_gui_input(event: InputEvent) -> void:
	card_state_machine.on_gui_input(event)

func _on_mouse_entered() -> void:
	card_state_machine.on_mouse_entered()

func _on_mouse_exited() -> void:
	card_state_machine.on_mouse_exited()

func _set_card(value: Card) -> void:
	if not is_node_ready():
		await ready
	
	card = value
	texture.texture = card.texture

func _set_playable(value: bool) -> void:
	playable = value
	if not playable:
		# fonte vermelha e modulate trasparente
		pass
	else:
		# fonte normal e modulate branco
		pass

func _set_char_stats(value: CharacterStats) -> void:
	char_stats = value
	char_stats.stats_changed.connect(_on_char_stats_changed)

func animate_to_position(new_position: Vector2, duration: float) -> void:
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", new_position, duration)

func play() -> void:
	if not card:
		return
	
	card.play(targets, char_stats)
	queue_free()

func _on_drop_point_detector_area_entered(area: Area2D) -> void:
	if not targets.has(area):
		targets.append(area)

func _on_drop_point_detector_area_exited(area: Area2D) -> void:
	targets.erase(area)


func _on_card_drag_or_aim_started(used_card: CardUI) -> void:
	if used_card == self:
		return
	
	disabled = true

func _on_card_drag_or_aim_ended(_card: CardUI) -> void:
	disabled = false
	self.playable = char_stats.can_play_card(card)


func _on_char_stats_changed() -> void:
	self.playable = char_stats.can_play_card(card)
