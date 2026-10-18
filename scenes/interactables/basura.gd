extends DragInteractable

@export var cesto: Node
@export var sfx_descarte: AudioStream = preload("res://assets/audio/sfx/BOLLITOPAPEL.wav")

func objetivo_valido() -> bool:
	var areas = get_overlapping_areas()
	for area in areas:
		if area == cesto:
			return true
	return false

func resolver_posicion_final() -> void:
	pass # la basura se queda donde fue soltada (y luego se oculta)

func on_interaccion_exitosa() -> void:
	if cesto and cesto.has_method("reproducir_sonido"):
		cesto.reproducir_sonido(sfx_descarte)
	cesto.intentar_interactuar()
	hide()
	monitoring = false
	
