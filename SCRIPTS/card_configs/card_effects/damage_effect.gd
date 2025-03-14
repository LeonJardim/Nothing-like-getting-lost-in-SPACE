class_name DamageEffect
extends Effect

var amount: int = 0

func execute(targets: Array[Node]) -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			target.take_damage(amount)
		elif target is Asteroid:
			target.queue_free()
