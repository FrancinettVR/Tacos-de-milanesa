extends ClickInteractable
class_name Puerta

var textura_cerrada = preload("res://assets/art/Zona1/Puerta_Cerrada.png")
var textura_abierta = preload("res://assets/art/Zona1/Puerta_Abierta.png")

@onready var audio_abrir: AudioStreamPlayer2D = get_node_or_null("AudioAbrir")
@onready var audio_cerrar: AudioStreamPlayer2D = get_node_or_null("AudioCerrar")
@onready var audio_bloqueada: AudioStreamPlayer2D = get_node_or_null("AudioBloqueada")

var abierta: bool = false

func al_iniciar() -> void:
	if id.is_empty():
		id = "puerta"
	sprite.texture = textura_cerrada

func on_interaccion_exitosa() -> void:
	usada = false # Permite interactuar según el estado actual
	
	# 1. Estado Bloqueado: Aún faltan tareas pendientes
	if not GameManager.todas_tareas_listas():
		if audio_bloqueada and audio_bloqueada.stream:
			audio_bloqueada.play()
		if DialogueUi:
			DialogueUi.mostrar_pensamiento("Quisiera tanto tomar aire un poco de aire")
		return
	
	# 2. Estado Desbloqueado: Primera vez con tareas completas -> Se abre la puerta
	if not abierta:
		abierta = true
		sprite.texture = textura_abierta
		if audio_abrir and audio_abrir.stream:
			audio_abrir.play()
		if DialogueUi:
			DialogueUi.mostrar_pensamiento("Por fin voy a poder respirar tranquila")
		return
	
	# 3. Estado Salida: Clic en la puerta abierta -> Salir al exterior
	if audio_cerrar and audio_cerrar.stream:
		audio_cerrar.play()
	
	var main_room = get_tree().current_scene
	if main_room and main_room.has_method("ejecutar_final"):
		main_room.ejecutar_final()
