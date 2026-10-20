extends ClickInteractable
class_name DialogInteractable

## Texto que se muestra en el panel de diálogo
@export var texto_dialogo: String = "ejemplo"

## Opciones que se muestran al hacer click en este objeto
@export var opciones: Array[OpcionDialogo] = []

var _dialogo_ui: DialogoUI

func _on_input_event(viewport, event, shape_idx) -> void:
	if usada:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		viewport.set_input_as_handled()
		_abrir_dialogo()

func _abrir_dialogo() -> void:
	if usada:
		return

	if opciones.is_empty():
		intentar_interactuar()
		return
	
	_dialogo_ui = get_tree().get_first_node_in_group("dialogo_ui") as DialogoUI
	if not _dialogo_ui:
		push_warning("No se encontró DialogoUI en la escena")
		return
	
	# Evitar abrir si ya hay un diálogo abierto
	if _dialogo_ui.esta_abierto():
		return

	# Desconectar si quedó una conexión previa pendiente
	if _dialogo_ui.opcion_elegida.is_connected(_on_opcion_elegida):
		_dialogo_ui.opcion_elegida.disconnect(_on_opcion_elegida)

	_dialogo_ui.opcion_elegida.connect(_on_opcion_elegida, CONNECT_ONE_SHOT)
	_dialogo_ui.mostrar_opciones(opciones, texto_dialogo)

func _on_opcion_elegida(opcion: OpcionDialogo) -> void:
	var sistema_estres = get_tree().get_first_node_in_group("sistema_estres")
	if sistema_estres and sistema_estres.has_method("modificar_estres"):
		sistema_estres.modificar_estres(opcion.delta_estres)
	
	intentar_interactuar()
