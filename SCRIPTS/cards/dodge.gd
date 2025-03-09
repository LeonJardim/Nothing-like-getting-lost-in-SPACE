extends Card

func apply_effects(targets: Array[Node]) -> void:
	var dodge_effect := DodgeEffect.new()
	dodge_effect.duration = 3
	dodge_effect.execute(targets)
	AudioManager.play_sfx("dodge")
