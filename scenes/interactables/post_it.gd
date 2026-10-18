# scripts/interactables-scripts/post_it.gd
extends ClickInteractable
class_name PostIt

@onready var audio_borrar: AudioStreamPlayer2D = get_node_or_null("AudioBorrar")

func al_iniciar() -> void:
	if id.is_empty():
		id = "post_it"

func on_interaccion_exitosa() -> void:
	if audio_borrar:
		audio_borrar.play()
	hide()
	monitoring = false
