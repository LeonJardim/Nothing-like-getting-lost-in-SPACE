class_name ShieldEffect
extends Effect

var amount: int = 0

func execute(targets: Array[Node]) -> void:
	for target in targets:
		if not target:
			continue
		if target is Enemy or target is Player:
			target.stats.shield += amount
