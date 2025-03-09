extends Node

var mus_sound = {
	"space_music": preload("res://AUDIO/music/Ludum Dare 38 10.ogg")
}
var sfx_sound = {
	"alien_laser": preload("res://AUDIO/sfx/alien_laser.wav"),
	"asteroid_destroyed": preload("res://AUDIO/sfx/asteroid_destroyed.wav"),
	"bomb": preload("res://AUDIO/sfx/bomb.wav"),
	"button_clicked": preload("res://AUDIO/sfx/button_clicked.wav"),
	"card_draw": preload("res://AUDIO/sfx/card_draw.wav"),
	"card_hover": preload("res://AUDIO/sfx/card_hover.wav"),
	"card_unplayable": preload("res://AUDIO/sfx/card_unplayable.wav"),
	"dodge": preload("res://AUDIO/sfx/dodge.wav"),
	"enemy_hurt": preload("res://AUDIO/sfx/enemy_hurt.wav"),
	"explosion": preload("res://AUDIO/sfx/explosion.wav"),
	"hurt": preload("res://AUDIO/sfx/hurt.wav"),
	"laser": preload("res://AUDIO/sfx/laser.wav"),
	"menu_slide": preload("res://AUDIO/sfx/menu_slide.wav"),
	"missile": preload("res://AUDIO/sfx/missile.wav"),
	"shield": preload("res://AUDIO/sfx/shield.wav"),
	"victory": preload("res://AUDIO/sfx/victory.wav")
}

@onready var music_player: AudioStreamPlayer = $MusicPlayer
@onready var sfx_players: Array[AudioStreamPlayer] = [
	$SFXPlayer1,
	$SFXPlayer2,
	$SFXPlayer3,
	$SFXPlayer4
]
@onready var menu_sfx_player: AudioStreamPlayer = $MenuSFXPlayer


func play_mus(music: String) -> void:
	if music in mus_sound:
		if music_player.stream != mus_sound[music] or !music_player.playing:
			music_player.stream = mus_sound[music]
			AudioServer.set_bus_volume_db(1, linear_to_db(Events.music_volume))
			music_player.volume_db = linear_to_db(Events.music_volume)
			music_player.play()

func play_sfx(fx: String) -> void:
	if fx in sfx_sound:
		for player in sfx_players:
			if !player.playing:
				player.stream = sfx_sound[fx]
				AudioServer.set_bus_volume_db(2, linear_to_db(Events.sfx_volume))
				player.volume_db = linear_to_db(Events.sfx_volume)
				player.play()
				return

func play_menu_sfx() -> void:
	if not menu_sfx_player.playing:
		AudioServer.set_bus_volume_db(2, linear_to_db(Events.sfx_volume))
		menu_sfx_player.volume_db = linear_to_db(Events.sfx_volume)
		menu_sfx_player.play()


func stop_mus() -> void:
	music_player.stop()

func stop_sfx() -> void:
	for player in sfx_players:
		player.stop()


func _on_music_player_finished() -> void:
	music_player.play()
