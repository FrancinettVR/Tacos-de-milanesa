extends Interactable
class_name Canasto

## Cantidad de prendas necesarias 
@export var total_prendas: int = 8
var prendas_depositadas: int = 0

## feedback temporal
@onready var color_rect: ColorRect = get_node_or_null("ColorRect")

func al_iniciar() -> void:
	if id.is_empty():
		id = "canasto"

func depositar_ropa() -> void:
	prendas_depositadas += 1
	# Al depositar todas las prendas requeridas, se completa la interacción
	if prendas_depositadas >= total_prendas:
		intentar_interactuar()

func on_interaccion_exitosa() -> void:
	# Color más oscuro cuando está lleno
	if color_rect:
		color_rect.color = Color(0.35, 0.22, 0.12)
