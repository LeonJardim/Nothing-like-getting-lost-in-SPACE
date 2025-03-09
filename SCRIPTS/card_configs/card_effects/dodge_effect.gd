class_name DodgeEffect
extends Effect

var duration: int = 0

func execute(targets: Array[Node]) -> void:
	for target in targets:
		if not target:
			continue
		if target is Player or target is Enemy:
			target.collision.disabled = true
			target.activate_dodge_visual()
			Events.player_started_dodging.emit(target, duration)
