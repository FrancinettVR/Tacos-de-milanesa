# scripts/interactables-scripts/puerta.gd
extends ClickInteractable
class_name Puerta

var textura_cerrada = preload("res://assets/art/interactables/placeholders/spr_puerta_cerrada.png")
var textura_abierta = preload("res://assets/art/interactables/placeholders/spr_puerta_abierta.png")

@onready var audio_puerta: AudioStreamPlayer2D = get_node_or_null("AudioPuerta")

func al_iniciar() -> void:
	if id.is_empty():
		id = "puerta"
	sprite.texture = textura_cerrada

func on_interaccion_exitosa() -> void:
	sprite.texture = textura_abierta
	if audio_puerta:
		audio_puerta.play()
