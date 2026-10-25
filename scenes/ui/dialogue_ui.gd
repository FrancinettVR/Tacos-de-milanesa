extends CanvasLayer
class_name DialogoUI

## Se emite cuando elige una opción
signal opcion_elegida(opcion: OpcionDialogo)
signal dialogo_cerrado

@onready var bloqueo_modal: Control = $BloqueoModal
@onready var label_texto: Label = $BloqueoModal/TarjetaDialogo/Margen/Contenido/LabelTexto
@onready var contenedor_opciones: HBoxContainer = $BloqueoModal/TarjetaDialogo/Margen/Contenido/ContenedorOpciones

func _ready() -> void:
	visible = false
	add_to_group("dialogo_ui")
	if bloqueo_modal:
		bloqueo_modal.gui_input.connect(_on_bloqueo_modal_gui_input)

func _on_bloqueo_modal_gui_input(event: InputEvent) -> void:
	if not visible:
		return
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if contenedor_opciones.get_child_count() == 1:
			var btn := contenedor_opciones.get_child(0) as Button
			if btn and is_instance_valid(btn):
				btn.pressed.emit()

func _unhandled_input(event: InputEvent) -> void:
	if not visible:
		return
	if event.is_action_pressed("ui_accept"):
		if contenedor_opciones.get_child_count() > 0:
			var btn := contenedor_opciones.get_child(0) as Button
			if btn and is_instance_valid(btn):
				btn.pressed.emit()
				get_viewport().set_input_as_handled()

## Indica si la ventana de diálogo está activa actualmente
func esta_abierto() -> bool:
	return visible

## Muestra el panel con el texto de pensamiento y un botón por cada opción recibida
func mostrar_opciones(opciones: Array[OpcionDialogo], texto: String = "") -> void:
	# Detener a la protagonista si estaba caminando hacia algún punto
	var protagonista := get_tree().get_first_node_in_group("protagonista")
	if protagonista and protagonista.has_method("stop"):
		protagonista.stop()

	label_texto.text = texto
	label_texto.visible = not texto.is_empty()
	_limpiar_botones()

	var estilo_normal := _crear_estilo_boton(
		Color(0.18, 0.18, 0.24, 0.92),
		Color(0.42, 0.46, 0.58, 0.65)
	)
	var estilo_hover := _crear_estilo_boton(
		Color(0.26, 0.27, 0.36, 0.98),
		Color(0.92, 0.82, 0.60, 1.0)
	)
	var estilo_pressed := _crear_estilo_boton(
		Color(0.12, 0.12, 0.17, 1.0),
		Color(0.75, 0.65, 0.45, 1.0)
	)

	for opcion in opciones:
		var boton := Button.new()
		boton.text = opcion.texto
		boton.custom_minimum_size = Vector2(170, 46)
		boton.mouse_default_cursor_shape = Control.CURSOR_POINTING_HAND
		
		# Tipografía y colores
		boton.add_theme_font_size_override("font_size", 18)
		boton.add_theme_color_override("font_color", Color(0.95, 0.95, 0.95, 1.0))
		boton.add_theme_color_override("font_hover_color", Color(1.0, 0.95, 0.85, 1.0))
		boton.add_theme_color_override("font_pressed_color", Color(0.85, 0.85, 0.85, 1.0))
		
		# Estilos visuales
		boton.add_theme_stylebox_override("normal", estilo_normal)
		boton.add_theme_stylebox_override("hover", estilo_hover)
		boton.add_theme_stylebox_override("pressed", estilo_pressed)
		boton.add_theme_stylebox_override("focus", estilo_hover)
		
		boton.pressed.connect(_on_opcion_pressed.bind(opcion))
		contenedor_opciones.add_child(boton)

	visible = true

## Muestra un pensamiento 
func mostrar_pensamiento(texto: String, texto_boton: String = "Continuar") -> void:
	var opc := OpcionDialogo.new()
	opc.texto = texto_boton
	opc.delta_estres = 0.0
	var lista: Array[OpcionDialogo] = [opc]
	mostrar_opciones(lista, texto)

func _on_opcion_pressed(opcion: OpcionDialogo) -> void:
	visible = false
	_limpiar_botones()
	opcion_elegida.emit(opcion)
	dialogo_cerrado.emit()

func _limpiar_botones() -> void:
	for child in contenedor_opciones.get_children():
		child.queue_free()

func _crear_estilo_boton(bg: Color, border: Color) -> StyleBoxFlat:
	var sb := StyleBoxFlat.new()
	sb.bg_color = bg
	sb.border_width_left = 2
	sb.border_width_top = 2
	sb.border_width_right = 2
	sb.border_width_bottom = 2
	sb.border_color = border
	sb.corner_radius_top_left = 10
	sb.corner_radius_top_right = 10
	sb.corner_radius_bottom_right = 10
	sb.corner_radius_bottom_left = 10
	sb.content_margin_left = 24
	sb.content_margin_right = 24
	sb.content_margin_top = 10
	sb.content_margin_bottom = 10
	return sb
