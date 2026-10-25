extends Control

@export var escena_juego: String = "res://scenes/rooms/main_room.tscn"

@onready var boton_jugar: Button = $ContenidoMenu/ContenedorOpciones/BotonJugar
@onready var boton_salir: Button = $ContenidoMenu/ContenedorOpciones/BotonSalir
@onready var cortina_fade: ColorRect = $CortinaFade

var _cambiando: bool = false

func _ready() -> void:
	boton_jugar.pressed.connect(_on_jugar_pressed)
	boton_salir.pressed.connect(_on_salir_pressed)
	
	_configurar_boton(boton_jugar)
	_configurar_boton(boton_salir)
	
	# Fundido de entrada al abrir el menú
	cortina_fade.visible = true
	cortina_fade.color = Color(0, 0, 0, 1)
	var tw_in := create_tween()
	tw_in.tween_property(cortina_fade, "color:a", 0.0, 0.4).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_OUT)
	await tw_in.finished
	cortina_fade.visible = false

func _configurar_boton(btn: Button) -> void:
	btn.pivot_offset = Vector2(160, 34)
	btn.mouse_entered.connect(func():
		if _cambiando:
			return
		var tw := create_tween()
		tw.tween_property(btn, "scale", Vector2(1.05, 1.05), 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	)
	btn.mouse_exited.connect(func():
		if _cambiando:
			return
		var tw := create_tween()
		tw.tween_property(btn, "scale", Vector2(1.0, 1.0), 0.15).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	)

func _on_jugar_pressed() -> void:
	if _cambiando:
		return
	_cambiando = true
	
	boton_jugar.disabled = true
	boton_salir.disabled = true
	
	# Fundido a negro antes de entrar al juego
	cortina_fade.visible = true
	cortina_fade.color = Color(0, 0, 0, 0)
	var tw_out := create_tween()
	tw_out.tween_property(cortina_fade, "color:a", 1.0, 0.4).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await tw_out.finished
	
	get_tree().change_scene_to_file(escena_juego)

func _on_salir_pressed() -> void:
	if _cambiando:
		return
	_cambiando = true
	
	boton_jugar.disabled = true
	boton_salir.disabled = true
	
	# Fundido de salida antes de cerrar
	cortina_fade.visible = true
	cortina_fade.color = Color(0, 0, 0, 0)
	var tw_quit := create_tween()
	tw_quit.tween_property(cortina_fade, "color:a", 1.0, 0.25).set_trans(Tween.TRANS_CUBIC).set_ease(Tween.EASE_IN)
	await tw_quit.finished
	
	get_tree().quit()
