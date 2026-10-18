# scripts/interactables-scripts/taza_bebible.gd
extends ClickInteractable
class_name TazaBebible

@onready var audio_sorbo: AudioStreamPlayer2D = get_node_or_null("AudioSorbo")

func al_iniciar() -> void:
	if id.is_empty():
		id = "taza_bebible"

func on_interaccion_exitosa() -> void:
	if audio_sorbo:
		audio_sorbo.play()
	hide()
	monitoring = false
