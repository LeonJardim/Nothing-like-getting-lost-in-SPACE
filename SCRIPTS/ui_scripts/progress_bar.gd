extends ProgressBar

@onready var timer: Timer = $Timer

var tween: Tween

func _ready() -> void:
	await get_tree().create_timer(2).timeout
	tween = create_tween().set_trans(Tween.TRANS_CIRC).set_ease(Tween.EASE_OUT)
	tween.tween_property(self, "position", Vector2(360,16), 2)

func _on_timer_timeout() -> void:
	value += step
	if value == max_value:
		Events.game_finished.emit()
		timer.stop()
	elif (int(value) % 60) == 0:
		Events.enemy_amount_difficulty += 1
