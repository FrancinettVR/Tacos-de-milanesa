extends CanvasLayer
class_name Celular

@export var intervalo: float = 10.0

@onready var panel: PanelNotificaciones = $Control/PanelNotificaciones
@onready var audio_vibracion: AudioStreamPlayer = $AudioVibracion
@onready var timer: Timer = $Timer

func _ready() -> void:
	visible = false
	panel.todas_descartadas.connect(_on_todas_descartadas)
	timer.wait_time = intervalo
	timer.timeout.connect(_on_timer_timeout)
	if es_disponible():
		timer.start()

func es_disponible() -> bool:
	return true

func _on_timer_timeout() -> void:
	if not es_disponible():
		return
	if visible:
		await ocultar_y_reaparecer()
	else:
		mostrar()

func mostrar() -> void:
	visible = true
	audio_vibracion.play()
	panel.poblar()

func ocultar_y_reaparecer() -> void:
	visible = false
	await get_tree().create_timer(1.0).timeout
	mostrar()

func _on_todas_descartadas() -> void:
	visible = false
