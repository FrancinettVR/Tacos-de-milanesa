extends Interactable
class_name DragInteractable

var arrastrando: bool = false
var posicion_inicial: Vector2
var offset_click: Vector2

func _ready() -> void:
	super._ready()
	input_event.connect(_on_input_event)
	posicion_inicial = position

func _on_input_event(viewport, event, shape_idx) -> void:
	if usada or arrastrando:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Evitar que iniciar el arrastre mueva a la protagonista
		viewport.set_input_as_handled()
		arrastrando = true
		offset_click = global_position - get_global_mouse_position()

func _input(event: InputEvent) -> void:
	if not arrastrando:
		return
	if event is InputEventMouseMotion:
		global_position = get_global_mouse_position() + offset_click
	elif event is InputEventMouseButton and not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		soltar()

func soltar() -> void:
	arrastrando = false
	if objetivo_valido():
		intentar_interactuar()
	resolver_posicion_final()

func resolver_posicion_final() -> void:
	position = posicion_inicial

# El hijo define qué significa "estar en el lugar correcto"
func objetivo_valido() -> bool:
	return false
