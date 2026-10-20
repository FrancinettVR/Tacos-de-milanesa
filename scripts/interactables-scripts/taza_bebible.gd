# scripts/interactables-scripts/taza_bebible.gd
extends ClickInteractable
class_name TazaBebible

@onready var audio_sorbo: AudioStreamPlayer2D = get_node_or_null("AudioSorbo")

func al_iniciar() -> void:
	if id.is_empty():
		id = "taza_bebible"

func on_interaccion_exitosa() -> void:
	if audio_sorbo and audio_sorbo.stream:
		audio_sorbo.play()
	var sistema_estres = get_tree().get_first_node_in_group("sistema_estres")
	if sistema_estres and sistema_estres.has_method("modificar_estres"):
		sistema_estres.modificar_estres(-10.0)
	hide()
	monitoring = false
