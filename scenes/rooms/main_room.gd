extends Node2D

## Caminar
@onready var protagonist: Protagonist = $Protagonist
## Click
@onready var click_area: Area2D = $ClickArea

func _ready() -> void:
	# Conectamos la señal de clic del área al método de movimiento
	click_area.input_event.connect(_on_click_area_input_event)

## Se ejecuta cuando el jugador hace clic en cualquier parte del escenario
func _on_click_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
		# get_global_mouse_position().x obtiene la coordenada X real en el mundo (0 a 5760 px)
		# posición relativa a la cámara
		protagonist.walk_to(get_global_mouse_position().x)
