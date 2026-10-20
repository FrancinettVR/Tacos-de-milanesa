# scripts/interactables-scripts/puerta.gd
extends ClickInteractable
class_name Puerta

var textura_cerrada = preload("res://assets/art/Zona1/Puerta_Cerrada.png")
var textura_abierta = preload("res://assets/art/Zona1/Puerta_Abierta.png")

@onready var audio_puerta: AudioStreamPlayer2D = get_node_or_null("AudioPuerta")

func al_iniciar() -> void:
	if id.is_empty():
		id = "puerta"
	sprite.texture = textura_abierta if usada else textura_cerrada

func on_interaccion_exitosa() -> void:
	sprite.texture = textura_abierta
	if audio_puerta and audio_puerta.stream:
		audio_puerta.play()
