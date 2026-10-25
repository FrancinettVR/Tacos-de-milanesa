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
	
	# Baja el estrés el equivalente a 2 notificaciones (-14 pts)
	if GameManager:
		GameManager.modificar_estres(-14.0)
	
	# Diálogo de pensamiento
	var opc := OpcionDialogo.new()
	opc.texto = "Continuar"
	opc.delta_estres = 0.0
	
	if DialogueUi:
		DialogueUi.mostrar_opciones([opc], "Sobrevivo a base de café")
		await DialogueUi.dialogo_cerrado
	
	hide()
	monitoring = false
