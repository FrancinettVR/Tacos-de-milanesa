extends Interactable
class_name Cesto

var textura_vacio = preload("res://assets/art/interactables/placeholders/spr_cesto_vacio.png")
var textura_lleno = preload("res://assets/art/interactables/placeholders/spr_cesto_lleno.png")

## Reproductor de audio genérico 
@onready var audio_descarte: AudioStreamPlayer2D = get_node_or_null("AudioStreamPlayer2D")

func al_iniciar() -> void:
	if id.is_empty():
		id = "cesto"
	sprite.texture = textura_vacio

## Reproduce cualquier sonido de descarte que le entregue el objeto
func reproducir_sonido(stream: AudioStream) -> void:
	if stream and audio_descarte:
		audio_descarte.stream = stream
		audio_descarte.play()

func on_interaccion_exitosa() -> void:
	sprite.texture = textura_lleno
