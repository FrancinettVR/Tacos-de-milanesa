extends DragInteractable
class_name Botella

## Referencia a la planta que debe ser regada
@export var planta: Node

var textura_llena = preload("res://assets/art/Zona2/Botella.png")
var textura_vacia = preload("res://assets/art/Zona2/BotellaVacía.png")

func al_iniciar() -> void:
	if id.is_empty():
		id = "botella"
	sprite.texture = textura_vacia if usada else textura_llena

func es_disponible() -> bool:
	return GameManager.puede_hacer_secundarias()

## Comprueba si la botella fue soltada encima 
func objetivo_valido() -> bool:
	var areas = get_overlapping_areas()
	for area in areas:
		if area == planta:
			return true
	return false

func on_interaccion_exitosa() -> void:
	sprite.texture = textura_vacia
	if planta and planta.has_method("regar"):
		planta.regar()
