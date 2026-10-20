extends TextureButton
class_name NotificacionItem

signal descartada

@export var opciones: Array[OpcionDialogo] = []

var _descartando: bool = false
var _drag_start_pos: Vector2 = Vector2.ZERO
var _is_dragging: bool = false
const SWIPE_THRESHOLD: float = 40.0

func _ready() -> void:
	pressed.connect(_on_pressed)

func _gui_input(event: InputEvent) -> void:
	if _descartando:
		return
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT:
			if event.pressed:
				_drag_start_pos = event.position
				_is_dragging = true
			else:
				if _is_dragging:
					var delta_x: float = event.position.x - _drag_start_pos.x
					_is_dragging = false
					if delta_x > SWIPE_THRESHOLD:
						# Descarte directo por gesto swipe a la derecha
						accept_event()
						_descartar()

func _on_pressed() -> void:
	if _descartando:
		return
	if opciones.is_empty():
		_descartar()
		return
	
	var dialogo_ui = get_tree().get_first_node_in_group("dialogo_ui")
	if not dialogo_ui:
		push_warning("No se encontró DialogoUI en la escena")
		_descartar()
		return
	
	dialogo_ui.opcion_elegida.connect(_on_opcion_elegida, CONNECT_ONE_SHOT)
	dialogo_ui.mostrar_opciones(opciones)

func _on_opcion_elegida(opcion: OpcionDialogo) -> void:
	var sistema_estres = get_tree().get_first_node_in_group("sistema_estres")
	if sistema_estres and sistema_estres.has_method("modificar_estres"):
		sistema_estres.modificar_estres(opcion.delta_estres)
	_descartar()

func _descartar() -> void:
	if _descartando:
		return
	_descartando = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Animación fluida de swipe hacia la derecha
	var tw := create_tween()
	tw.set_parallel(true)
	tw.tween_property(self, "position:x", position.x + 80.0, 0.15).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tw.tween_property(self, "modulate:a", 0.0, 0.15)
	await tw.finished
	
	descartada.emit()
	queue_free()

func configurar_indice(_idx: int) -> void:
	pass
