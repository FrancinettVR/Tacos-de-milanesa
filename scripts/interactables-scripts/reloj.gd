extends ClickInteractable
class_name Reloj

const S_NORMAL = preload("res://assets/audio/audio/OBJETOS/RELOJ/TICTAC.wav")
const S_LENTO = preload("res://assets/audio/audio/OBJETOS/RELOJ/TICTAC_LENTO.wav")
const S_MOLESTO = preload("res://assets/audio/audio/OBJETOS/RELOJ/TICTAC2_MOLESTO.wav")

@onready var audio_tictac: AudioStreamPlayer2D = $AudioStreamPlayer2D

var _corriente_stream: AudioStream = null

func al_iniciar() -> void:
	if id.is_empty():
		id = "reloj"

func _process(_delta: float) -> void:
	_actualizar_audio_reloj()

func _actualizar_audio_reloj() -> void:
	if not audio_tictac:
		return
	
	if GameManager.reloj_silenciado:
		if audio_tictac.playing:
			audio_tictac.stop()
		return
	
	# Chequear si la protagonista está en Zona 2 (x entre 1920 y 3840)
	var protagonista := get_tree().get_first_node_in_group("protagonista") as Node2D
	if not protagonista:
		if audio_tictac.playing:
			audio_tictac.stop()
		return
	
	var px: float = protagonista.global_position.x
	var en_zona_2: bool = (px >= 1920.0 and px <= 3840.0)
	
	# Consultar nivel de estrés actual (0.0 a 1.0)
	var sistema_estres = get_tree().get_first_node_in_group("sistema_estres")
	var nivel_estres: float = 0.0
	if sistema_estres:
		if sistema_estres.has_method("get_estres"):
			nivel_estres = sistema_estres.get_estres()
		elif "nivel_estres" in sistema_estres:
			nivel_estres = sistema_estres.nivel_estres
	
	if not en_zona_2 or nivel_estres < 0.20:
		if audio_tictac.playing:
			audio_tictac.stop()
		_corriente_stream = null
		return
	
	# Determinar tier según tercio
	var nuevo_stream: AudioStream = null
	if nivel_estres < 0.47:
		nuevo_stream = S_NORMAL
	elif nivel_estres < 0.73:
		nuevo_stream = S_LENTO
	else:
		nuevo_stream = S_MOLESTO
	
	if _corriente_stream != nuevo_stream:
		_corriente_stream = nuevo_stream
		audio_tictac.stream = nuevo_stream
		audio_tictac.play()
	elif not audio_tictac.playing:
		audio_tictac.play()

func on_interaccion_exitosa() -> void:
	if GameManager.reloj_silenciado:
		return
	
	GameManager.marcar_reloj_silenciado()
	if audio_tictac and audio_tictac.playing:
		audio_tictac.stop()
	
	if DialogueUi:
		DialogueUi.mostrar_pensamiento("El tictac me estaba volviendo loca... mucho mejor así.")
