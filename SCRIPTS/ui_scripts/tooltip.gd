class_name Tooltip
extends Panel

@onready var cost_text: Label = %CostText
@onready var card_icon: TextureRect = %CardIcon
@onready var card_text: Label = %CardText
@onready var target_icon: TextureRect = %TargetIcon
@onready var target_text: Label = %TargetText
var tween: Tween

func _ready() -> void:
	Events.card_tooltip_requested.connect(show_tooltip)
	Events.tooltip_hide_requested.connect(hide_tooltip)

func show_tooltip(_costText:String,_cardIcon:Texture,_cardText:String,_targetIcon:Texture,_targetText:int) -> void:
	if tween:
		tween.kill()
	
	cost_text.text = "Costs " + _costText + " energy"
	card_icon.texture = _cardIcon
	card_text.text = _cardText
	target_icon.texture = _targetIcon
	match _targetText:
		0: target_text.text = "Self"
		1: target_text.text = "Single Target"
		2: target_text.text = "All Enemies"
		3: target_text.text = "Everyone"
	
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", Vector2(952,364), 1)

func hide_tooltip() -> void:
	if tween:
		tween.kill()
	
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "global_position", Vector2(1352,364), 1)
