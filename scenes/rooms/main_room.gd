extends Node2D

## Caminar
@onready var protagonist: Protagonist = $Protagonist
## Click
@onready var click_area: Area2D = $ClickArea
## Fondo 3D
@onready var habitacion_3d: Habitacion3D = $Env/Fondo3DLayer/SubViewportContainer/SubViewport/Habitacion3D

func _ready() -> void:
	# Conectamos la señal de clic del área al método de movimiento
	click_area.input_event.connect(_on_click_area_input_event)

func _process(_delta: float) -> void:
	_sincronizar_fondo_3d()

## Se ejecuta cuando el jugador hace clic en cualquier parte del escenario
func _on_click_area_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
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
