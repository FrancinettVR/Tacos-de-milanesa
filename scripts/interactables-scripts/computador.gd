extends ClickInteractable
class_name Computador

@export var correos_iniciales: int = 3
@export var intervalo_correo: float = 20.0

var correos: int = 3
var apagado: bool = false

@onready var timer_correo: Timer = $TimerCorreo
@onready var audio_notif: AudioStreamPlayer2D = $AudioNotif
@onready var pantalla_apagada: ColorRect = $"../PantallaApagada"

func al_iniciar() -> void:
	if id.is_empty():
		id = "computador"
	correos = correos_iniciales
	if timer_correo:
		timer_correo.wait_time = intervalo_correo
		timer_correo.timeout.connect(_on_timer_correo_timeout)
		timer_correo.start()

func _on_timer_correo_timeout() -> void:
	if apagado:
		timer_correo.stop()
		return
	
	# Verificar si el celular está activo/visible para no solaparse
	var celular = get_tree().get_first_node_in_group("celular")
	if celular and celular.visible:
		# Posponer unos segundos para evitar solapamiento
		timer_correo.start(5.0)
		return
	
	correos += 1
	if audio_notif and audio_notif.stream:
		audio_notif.play()

func on_interaccion_exitosa() -> void:
	usada = false # Permitir volver a interactuar
	
	if apagado:
		if DialogueUi:
			DialogueUi.mostrar_pensamiento("La computadora ya está apagada.")
		return
	
	_mostrar_menu_principal()

func _mostrar_menu_principal() -> void:
	var dialogo := get_tree().get_first_node_in_group("dialogo_ui") as DialogoUI
	if not dialogo or dialogo.esta_abierto():
		return
	
	var opc_leer := OpcionDialogo.new()
	opc_leer.texto = "Leer correo"
	opc_leer.delta_estres = 0.0
	
	var opc_apagar := OpcionDialogo.new()
	opc_apagar.texto = "Apagar"
	opc_apagar.delta_estres = 0.0
	
	var opc_ignorar := OpcionDialogo.new()
	opc_ignorar.texto = "Ignorar"
	opc_ignorar.delta_estres = 0.0
	
	dialogo.opcion_elegida.connect(_on_opcion_principal, CONNECT_ONE_SHOT)
	var texto_prompt := "Tienes " + str(correos) + " correos no leídos"
	var lista: Array[OpcionDialogo] = [opc_leer, opc_apagar, opc_ignorar]
	dialogo.mostrar_opciones(lista, texto_prompt)

func _on_opcion_principal(opcion: OpcionDialogo) -> void:
	match opcion.texto:
		"Leer correo":
			_leer_correo()
		"Ignorar":
			# Ignorar suma +4 pts de estrés por culpa
			GameManager.modificar_estres(4.0)
		"Apagar":
			_proponer_apagar()

func _leer_correo() -> void:
	if correos > 0:
		correos -= 1
		# Leer 1 correo suma +8 pts de estrés
		GameManager.modificar_estres(8.0)
		if DialogueUi:
			DialogueUi.mostrar_pensamiento("Otro correo marcando que el proyecto es de máxima prioridad... Me tiemblan las manos.")
	else:
		if DialogueUi:
			DialogueUi.mostrar_pensamiento("No tienes correos nuevos por ahora.")

func _proponer_apagar() -> void:
	var dialogo := get_tree().get_first_node_in_group("dialogo_ui") as DialogoUI
	if not dialogo:
		return
	
	var opc_apagar_si := OpcionDialogo.new()
	opc_apagar_si.texto = "Apagar de todas formas"
	opc_apagar_si.delta_estres = 0.0
	
	var opc_volver := OpcionDialogo.new()
	opc_volver.texto = "Seguir trabajando"
	opc_volver.delta_estres = 0.0
	
	dialogo.opcion_elegida.connect(_on_opcion_apagar_confirmacion, CONNECT_ONE_SHOT)
	var lista: Array[OpcionDialogo] = [opc_apagar_si, opc_volver]
	dialogo.mostrar_opciones(lista, "Necesito terminar este encargo")

func _on_opcion_apagar_confirmacion(opcion: OpcionDialogo) -> void:
	if opcion.texto == "Apagar de todas formas":
		apagado = true
		usada = true
		if timer_correo:
			timer_correo.stop()
		if pantalla_apagada:
			pantalla_apagada.visible = true
		GameManager.marcar_computador_apagado()
		
		# Mostrar diálogo de alivio
		if DialogueUi:
			DialogueUi.mostrar_pensamiento("Me siento algo mejor")
