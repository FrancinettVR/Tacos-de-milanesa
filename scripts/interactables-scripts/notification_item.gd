extends TextureButton
class_name NotificacionItem

signal descartada

@export var opciones: Array[OpcionDialogo] = []

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
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
	descartada.emit()
	queue_free()
