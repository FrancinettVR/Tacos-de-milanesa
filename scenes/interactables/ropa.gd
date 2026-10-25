extends DragInteractable
class_name Ropa

## Referencia al canasto donde se debe depositar la ropa
@export var canasto: Node

func al_iniciar() -> void:
	if id.is_empty():
		id = "ropa"

func es_disponible() -> bool:
	return GameManager.puede_hacer_secundarias()

## Comprueba si se soltó sobre el canasto
func objetivo_valido() -> bool:
	var areas = get_overlapping_areas()
	for area in areas:
		if area == canasto:
			return true
	return false

func resolver_posicion_final() -> void:
	pass # La ropa se queda donde fue soltada y se oculta

func on_interaccion_exitosa() -> void:
	if canasto and canasto.has_method("depositar_ropa"):
		canasto.depositar_ropa()
	elif canasto and canasto.has_method("intentar_interactuar"):
		canasto.intentar_interactuar()
	hide()
	monitoring = false
