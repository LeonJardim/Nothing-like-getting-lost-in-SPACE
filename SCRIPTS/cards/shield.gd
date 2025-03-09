extends Card

func apply_effects(targets: Array[Node]) -> void:
	var shield_effect := ShieldEffect.new()
	shield_effect.amount = 4
	shield_effect.execute(targets)
	AudioManager.play_sfx("shield")
