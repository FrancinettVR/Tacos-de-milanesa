extends Button
class_name NotificacionItem

signal descartada

const MENSAJES := [
	"¿Tenés listo el informe de las 9?",
	"8 mensajes urgentes sin responder",
	"Reunión de equipo en 5 minutos",
	"Revisar cambios pendientes del proyecto"
]

@onready var label_app: Label = $Margen/VBox/LabelApp
@onready var label_texto: Label = $Margen/VBox/LabelTexto

var _descartando: bool = false

func _ready() -> void:
	pressed.connect(_on_pressed)

func configurar_indice(idx: int) -> void:
	if label_app:
		label_app.text = "NOTIFICACIÓN"
	if label_texto:
		label_texto.text = MENSAJES[idx % MENSAJES.size()]

func _on_pressed() -> void:
	if _descartando:
		return
	_descartando = true
	mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# Descarte swipe hacia la derecha
	var tw := create_tween()
	tw.set_parallel(true)
	tw.tween_property(self, "position:x", position.x + 80.0, 0.15).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	tw.tween_property(self, "modulate:a", 0.0, 0.15)
	await tw.finished
	
	descartada.emit()
	queue_free()
