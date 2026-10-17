extends DragInteractable

@export var planta: Node

var textura_llena = preload("res://assets/art/interactables/placeholders/spr_botella_llena.png")
var textura_vacia = preload("res://assets/art/interactables/placeholders/spr_botella_vacia.png")

func al_iniciar() -> void:
	sprite.texture = textura_llena

func objetivo_valido() -> bool:
	var areas = get_overlapping_areas()
	for area in areas:
		if area == planta:
			return true
	return false
	
func on_interaccion_exitosa() -> void:
	sprite.texture = textura_vacia
	planta.regar()
