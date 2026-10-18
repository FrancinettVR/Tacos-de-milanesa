extends CanvasLayer
class_name DialogoUI

## Se emite cuando el jugador elige una opción
signal opcion_elegida(opcion: OpcionDialogo)

@onready var contenedor_opciones: HBoxContainer = $PanelDialogo/ContenedorOpciones

func _ready() -> void:
	visible = false
	add_to_group("dialogo_ui")

## Muestra el panel con un botón por cada opción recibida
func mostrar_opciones(opciones: Array[OpcionDialogo]) -> void:
	_limpiar_botones()
	for opcion in opciones:
		var boton := Button.new()
		boton.text = opcion.texto
		boton.pressed.connect(_on_opcion_pressed.bind(opcion))
		contenedor_opciones.add_child(boton)
	visible = true

func _on_opcion_pressed(opcion: OpcionDialogo) -> void:
	visible = false
	_limpiar_botones()
	opcion_elegida.emit(opcion)

func _limpiar_botones() -> void:
	for child in contenedor_opciones.get_children():
		child.queue_free()
