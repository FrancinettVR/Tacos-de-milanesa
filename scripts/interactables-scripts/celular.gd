extends CanvasLayer
class_name Celular

@export var intervalo: float = 12.0

@onready var control: Control = $Control
@onready var fondo_celular: TextureRect = $Control/FondoCelular
@onready var boton_apagar: Button = $Control/BotonApagar
@onready var panel: PanelNotificaciones = $Control/PanelNotificaciones
@onready var audio_vibracion: AudioStreamPlayer = $AudioVibracion
@onready var timer: Timer = $Timer

var textura_prendida := preload("res://assets/art/interactables/Celular_Prendido.png")
var textura_apagada := preload("res://assets/art/interactables/Celular_Apagado.png")

var _pos_visible_y: float = 200.0
var _pos_oculta_y: float = 1100.0
var _esta_animando: bool = false
var apagado: bool = false

func _ready() -> void:
	add_to_group("celular")
	visible = false
	offset.y = _pos_oculta_y
	panel.todas_descartadas.connect(_on_todas_descartadas)
	if boton_apagar:
		boton_apagar.pressed.connect(_on_boton_apagar_pressed)
	timer.one_shot = true
	timer.wait_time = intervalo
	timer.timeout.connect(_on_timer_timeout)
	if es_disponible():
		timer.start()

func es_disponible() -> bool:
	return not apagado

func _on_timer_timeout() -> void:
	if not es_disponible() or visible:
		return
	mostrar()

func mostrar() -> void:
	if _esta_animando or apagado:
		return
	_esta_animando = true
	timer.stop() # Fix, detiene el timer mientras el celular esta abierto
	fondo_celular.texture = textura_prendida
	if boton_apagar:
		boton_apagar.visible = true
	visible = true
	panel.poblar()
	
	# Sonido de vibración
	if audio_vibracion and audio_vibracion.stream:
		audio_vibracion.play()
	
	# Animación de entrada
	var tw := create_tween()
	tw.set_trans(Tween.TRANS_BACK).set_ease(Tween.EASE_OUT)
	tw.tween_property(self, "offset:y", _pos_visible_y, 0.45)
	await tw.finished
	
	# Animación de vibración
	await _animar_vibracion()
	_esta_animando = false

## Simula la vibración
func _animar_vibracion() -> void:
	var tw := create_tween()
	for i in range(4):
		var angulo := deg_to_rad(-2.0 if i % 2 == 0 else 2.0)
		tw.tween_property(control, "rotation", angulo, 0.05)
	tw.tween_property(control, "rotation", 0.0, 0.05)
	await tw.finished

func _on_boton_apagar_pressed() -> void:
	if _esta_animando or apagado:
		return
	
	var opc_apagar := OpcionDialogo.new()
	opc_apagar.texto = "Apagar el teléfono"
	opc_apagar.delta_estres = 0.0
	
	var opc_dejar := OpcionDialogo.new()
	opc_dejar.texto = "Dejarlo encendido"
	opc_dejar.delta_estres = 0.0
	
	var dialogo := get_tree().get_first_node_in_group("dialogo_ui") as DialogoUI
	if not dialogo:
		return
	
	if dialogo.opcion_elegida.is_connected(_on_dialogo_opcion_elegida):
		dialogo.opcion_elegida.disconnect(_on_dialogo_opcion_elegida)
	
	dialogo.opcion_elegida.connect(_on_dialogo_opcion_elegida, CONNECT_ONE_SHOT)
	var texto_duda := "¿Y si alguien me necesita con urgencia del trabajo? Van a pensar que soy irresponsable..."
	var lista_opciones: Array[OpcionDialogo] = [opc_apagar, opc_dejar]
	dialogo.mostrar_opciones(lista_opciones, texto_duda)

func _on_dialogo_opcion_elegida(opcion: OpcionDialogo) -> void:
	if opcion.texto == "Apagar el teléfono":
		GameManager.marcar_celular_apagado()
		apagar_telefono()

func apagar_telefono() -> void:
	if _esta_animando:
		return
	_esta_animando = true
	apagado = true
	timer.stop() # Congela el timer de notificaciones definitivamente
	panel.limpiar()
	if boton_apagar:
		boton_apagar.visible = false
	
	# Pasar el arte a pantalla apagada
	fondo_celular.texture = textura_apagada
	
	# Breve pausa para mostrar la pantalla apagada antes de esconder
	await get_tree().create_timer(0.6).timeout
	
	# Animación de salida
	var tw := create_tween()
	tw.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tw.tween_property(self, "offset:y", _pos_oculta_y, 0.45)
	await tw.finished
	
	visible = false
	_esta_animando = false

func _on_todas_descartadas() -> void:
	if _esta_animando or apagado:
		return
	_esta_animando = true
	
	# Animación de salida
	var tw := create_tween()
	tw.set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	tw.tween_property(self, "offset:y", _pos_oculta_y, 0.4)
	await tw.finished
	
	visible = false
	_esta_animando = false
	
	if es_disponible():
		timer.start(intervalo)
