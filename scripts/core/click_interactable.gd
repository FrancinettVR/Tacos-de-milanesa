extends Interactable
class_name ClickInteractable

func _ready() -> void:
	super._ready()
	input_event.connect(_on_input_event)

func _on_input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Evitar que el clic en el fondo haga que camine
		viewport.set_input_as_handled()
		intentar_interactuar()
