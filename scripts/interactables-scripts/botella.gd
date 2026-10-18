extends DragInteractable
class_name Botella

## Referencia a la planta que debe ser regada
@export var planta: Node

var textura_llena = preload("res://assets/art/Zona2/Botella.png")

func al_iniciar() -> void:
	if id.is_empty():
		id = "botella"
	sprite.texture = textura_llena

## Comprueba si la botella fue soltada encima 
func objetivo_valido() -> bool:
	var areas = get_overlapping_areas()
	for area in areas:
		if area == planta:
			return true
	return false

func on_interaccion_exitosa() -> void:
	# No hay arte para botella vacía, por lo que mantiene su estado lleno
	if planta and planta.has_method("regar"):
		planta.regar()
