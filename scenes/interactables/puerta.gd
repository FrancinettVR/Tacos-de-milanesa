# scripts/interactables-scripts/puerta.gd
extends ClickInteractable
class_name Puerta

var textura_cerrada = preload("res://assets/art/Zona1/Puerta_Cerrada.png")
var textura_abierta = preload("res://assets/art/Zona1/Puerta_Abierta.png")

@onready var audio_abrir: AudioStreamPlayer2D = get_node_or_null("AudioAbrir")
@onready var audio_cerrar: AudioStreamPlayer2D = get_node_or_null("AudioCerrar")

var abierta: bool = false

func al_iniciar() -> void:
	if id.is_empty():
		id = "puerta"
	sprite.texture = textura_cerrada

func on_interaccion_exitosa() -> void:
	abierta = not abierta
	usada = false # permite volver a clickear (toggle)
	
	if abierta:
		sprite.texture = textura_abierta
		if audio_abrir and audio_abrir.stream:
			audio_abrir.play()
	else:
		sprite.texture = textura_cerrada
		if audio_cerrar and audio_cerrar.stream:
			audio_cerrar.play()
