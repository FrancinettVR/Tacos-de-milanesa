extends Area2D
class_name Interactable

@export var id: String = ""
@onready var sprite: Sprite2D = get_node_or_null("Sprite2D")

var usada: bool = false

func _ready() -> void:
	al_iniciar()

# TODO: por ahora hardcodeado a true para poder probar el sistema.
# Más adelante esto debe consultar al GameManager si el foco de estrés
# correspondiente ya fue resuelto.
func es_disponible() -> bool:
	return true

func intentar_interactuar() -> void:
	if usada:
		return
	if not es_disponible():
		EventBus.interaccion_bloqueada.emit(id)
		if DialogueUi:
			DialogueUi.mostrar_pensamiento("No puedo ocuparme de esto con tanto trabajo pendiente")
		return
	interactuar()

func interactuar() -> void:
	usada = true
	on_interaccion_exitosa()
	EventBus.interaccion_completada.emit(id)

# --- Para que cada hijo sobreescriba ---

func al_iniciar() -> void:
	pass

func on_interaccion_exitosa() -> void:
	pass
