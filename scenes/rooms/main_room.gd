extends Node2D

## Caminar
@onready var protagonist: Protagonist = $Protagonist
## Click
@onready var click_area: Area2D = $ClickArea
## Fondo 3D
@onready var habitacion_3d: Habitacion3D = $Env/Fondo3DLayer/SubViewportContainer/SubViewport/Habitacion3D
## Celular
@onready var celular: Celular = $Celular

## Intro inicial
@onready var intro_layer: CanvasLayer = $IntroLayer
@onready var fondo_negro: ColorRect = $IntroLayer/FondoNegro
@onready var audio_intro: AudioStreamPlayer = $IntroLayer/AudioIntro

var _en_intro: bool = true

func _ready() -> void:
	# Conectamos la señal de clic del área al método de movimiento
	click_area.input_event.connect(_on_click_area_input_event)
	_ejecutar_secuencia_intro()

func _process(_delta: float) -> void:
	_sincronizar_fondo_3d()

## Secuencia inicial
func _ejecutar_secuencia_intro() -> void:
	_en_intro = true
	
	# Pausar timer del celular durante la cinemática de inicio
	if is_instance_valid(celular) and is_instance_valid(celular.timer):
		celular.timer.stop()
	
	# Pantalla negra 
	if fondo_negro:
		fondo_negro.color = Color(0, 0, 0, 1)
		fondo_negro.mouse_filter = Control.MOUSE_FILTER_STOP
	if intro_layer:
		intro_layer.visible = true
	
	# 1. Pausa inicial en oscuridad y silencio (1 segundo)
	await get_tree().create_timer(1.0).timeout
	
	# 2. Suena la notificación y vibración del celular
	if audio_intro and audio_intro.stream:
		audio_intro.play()
		await audio_intro.finished
	else:
		await get_tree().create_timer(2.2).timeout
	
	# Pausa tras la vibración
	await get_tree().create_timer(0.4).timeout
	
	# 3. Se abre la ventana de diálogo
	var opc := OpcionDialogo.new()
	opc.texto = "Continuar"
	opc.delta_estres = 0.0
	
	if DialogueUi:
		DialogueUi.mostrar_opciones([opc], "¿Qué hora es? Me duele todo…")
		await DialogueUi.dialogo_cerrado
	
	# 4. Una vez que el jugador pasa ese diálogo, la pantalla deja de ser negra
	if fondo_negro:
		var tw := create_tween()
		tw.tween_property(fondo_negro, "color:a", 0.0, 1.2).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
		await tw.finished
		fondo_negro.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	if intro_layer:
		intro_layer.visible = false
	
	# Reanudar el ciclo de notificaciones del celular
	if is_instance_valid(celular) and is_instance_valid(celular.timer) and celular.es_disponible():
		celular.timer.start()
	
	# El jugador toma control del personaje
	_en_intro = false

## Se ejecuta cuando el jugador hace clic en cualquier parte del escenario
func _on_click_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if _en_intro:
		return
	if DialogueUi and DialogueUi.esta_abierto():
		return
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# get_global_mouse_position().x obtiene la coordenada X real en el mundo (0 a 5760 px)
		protagonist.walk_to(get_global_mouse_position().x)

## Sincroniza la posición X de la cámara 3D con la cámara 2D del protagonista
func _sincronizar_fondo_3d() -> void:
	if not is_instance_valid(habitacion_3d) or not is_instance_valid(protagonist):
		return
	var cam2d := protagonist.get_node_or_null("Camera2D") as Camera2D
	if not cam2d:
		return
	# get_screen_center_position() devuelve la posición central actual de la cámara 2D en el mundo
	var cam2d_x: float = cam2d.get_screen_center_position().x
	# Sincronización lineal exacta 1:1: 1 metro en 3D = 1000 píxeles en 2D (cero deslizamiento)
	var cam3d_x: float = (cam2d_x - 2880.0) / 1000.0
	habitacion_3d.sincronizar_camara_x(cam3d_x)

## Secuencia de salida y epílogo
func ejecutar_final() -> void:
	_en_intro = true
	if protagonist and protagonist.has_method("stop"):
		protagonist.stop()
	
	# Detener timer del celular
	if is_instance_valid(celular) and is_instance_valid(celular.timer):
		celular.timer.stop()
	
	# Fundido a color celeste amanecer: Color(0.68, 0.85, 0.98)
	if intro_layer and fondo_negro:
		intro_layer.visible = true
		fondo_negro.mouse_filter = Control.MOUSE_FILTER_STOP
		fondo_negro.color = Color(0.68, 0.85, 0.98, 0.0)
		var tw := create_tween()
		tw.tween_property(fondo_negro, "color:a", 1.0, 1.4).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN_OUT)
	
	# Reproducción de ambiente exterior (aves y brisa suave)
	var audio_aves := get_node_or_null("AudioAves") as AudioStreamPlayer
	var audio_viento := get_node_or_null("AudioViento") as AudioStreamPlayer
	if audio_aves:
		audio_aves.play()
	if audio_viento:
		audio_viento.play()
	
	await get_tree().create_timer(1.8).timeout
	
	# Diálogo final reflexivo
	var opc := OpcionDialogo.new()
	opc.texto = "Continuar"
	opc.delta_estres = 0.0
	
	if DialogueUi:
		DialogueUi.mostrar_opciones([opc], "Es necesario saber cuando parar")
		await DialogueUi.dialogo_cerrado
	
	# Fundido suave y retorno a la pantalla de título
	if fondo_negro:
		var tw_out := create_tween()
		tw_out.tween_property(fondo_negro, "color", Color(0, 0, 0, 1), 1.0)
		await tw_out.finished
	
	get_tree().change_scene_to_file("res://scenes/intro/main_menu.tscn")

