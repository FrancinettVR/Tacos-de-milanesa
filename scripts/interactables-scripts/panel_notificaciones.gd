extends VBoxContainer
class_name PanelNotificaciones

signal todas_descartadas

@export var notificacion_scene: PackedScene
@export var cantidad: int = 4

var restantes: int = 0

func poblar() -> void:
	limpiar()
	restantes = cantidad
	for i in range(cantidad):
		var item: NotificacionItem = notificacion_scene.instantiate()
		add_child(item)
		if item.has_method("configurar_indice"):
			item.configurar_indice(i)
		item.descartada.connect(_on_item_descartada)

func limpiar() -> void:
	restantes = 0
	for child in get_children():
		child.queue_free()

func _on_item_descartada() -> void:
	restantes -= 1
	if restantes <= 0:
		todas_descartadas.emit()
