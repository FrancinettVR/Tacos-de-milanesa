extends HBoxContainer
class_name PanelNotificaciones

signal todas_descartadas

@export var notificacion_scene: PackedScene
@export var cantidad: int = 4

func poblar() -> void:
	limpiar()
	for i in range(cantidad):
		var item: NotificacionItem = notificacion_scene.instantiate()
		add_child(item)
		item.descartada.connect(_on_item_descartada)

func limpiar() -> void:
	for child in get_children():
		child.queue_free()

func _on_item_descartada() -> void:
	await get_tree().process_frame
	if get_child_count() == 0:
		todas_descartadas.emit()
