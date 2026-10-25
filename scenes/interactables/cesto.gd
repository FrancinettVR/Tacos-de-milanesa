extends Interactable
class_name Cesto

var textura_vacio = preload("res://assets/art/interactables/placeholders/spr_cesto_vacio.png")
var textura_lleno = preload("res://assets/art/interactables/placeholders/spr_cesto_lleno.png")

@export var total_basura: int = 5
var basura_depositada: int = 0

## Reproductor de audio genérico 
@onready var audio_descarte: AudioStreamPlayer2D = get_node_or_null("AudioStreamPlayer2D")

func al_iniciar() -> void:
	if id.is_empty():
		id = "cesto"
	sprite.texture = textura_vacio

func es_disponible() -> bool:
	return GameManager.puede_hacer_secundarias()

## Reproduce cualquier sonido de descarte que le entregue el objeto
func reproducir_sonido(stream: AudioStream) -> void:
	if stream and audio_descarte:
		audio_descarte.stream = stream
		audio_descarte.play()

func depositar_basura() -> void:
	basura_depositada += 1
	if basura_depositada >= total_basura:
		GameManager.marcar_basura_recogida()
		intentar_interactuar()

func on_interaccion_exitosa() -> void:
	sprite.texture = textura_lleno
