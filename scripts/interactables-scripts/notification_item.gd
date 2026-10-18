extends TextureButton
class_name NotificacionItem

signal descartada

func _ready() -> void:
	pressed.connect(_on_pressed)

func _on_pressed() -> void:
	descartada.emit()
	queue_free()
