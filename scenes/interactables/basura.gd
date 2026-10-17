extends DragInteractable

@export var cesto: Node

func objetivo_valido() -> bool:
	var areas = get_overlapping_areas()
	for area in areas:
		if area == cesto:
			return true
	return false

func resolver_posicion_final() -> void:
	pass # la basura se queda donde fue soltada (y luego se oculta)

func on_interaccion_exitosa() -> void:
	cesto.intentar_interactuar()
	hide()
	monitoring = false
	
