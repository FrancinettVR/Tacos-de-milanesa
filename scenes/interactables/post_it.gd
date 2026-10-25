extends ClickInteractable
class_name PostIt

@export_multiline var texto_encargo: String = ""
@onready var audio_borrar: AudioStreamPlayer2D = get_node_or_null("AudioBorrar")

func al_iniciar() -> void:
	if id.is_empty():
		id = "post_it"

func on_interaccion_exitosa() -> void:
	usada = false # Permitir volver a interactuar si solo leyó o canceló
	_mostrar_menu_postit()

func _mostrar_menu_postit() -> void:
	var dialogo := get_tree().get_first_node_in_group("dialogo_ui") as DialogoUI
	if not dialogo or dialogo.esta_abierto():
		return
	
	var opc_leer := OpcionDialogo.new()
	opc_leer.texto = "Leer"
	opc_leer.delta_estres = 0.0
	
	var opc_tirar := OpcionDialogo.new()
	opc_tirar.texto = "Tirar"
	opc_tirar.delta_estres = 0.0
	
	var opc_dejar := OpcionDialogo.new()
	opc_dejar.texto = "Dejarla"
	opc_dejar.delta_estres = 0.0
	
	dialogo.opcion_elegida.connect(_on_opcion_postit, CONNECT_ONE_SHOT)
	var lista: Array[OpcionDialogo] = [opc_leer, opc_tirar, opc_dejar]
	dialogo.mostrar_opciones(lista, "¿Qué hago con esta nota?")

func _on_opcion_postit(opcion: OpcionDialogo) -> void:
	if opcion.texto == "Leer":
		GameManager.modificar_estres(6.0)
		var dialogo := get_tree().get_first_node_in_group("dialogo_ui") as DialogoUI
		if dialogo:
			dialogo.mostrar_pensamiento(texto_encargo)
	elif opcion.texto == "Tirar":
		usada = true
		if audio_borrar:
			audio_borrar.play()
		GameManager.marcar_postit_tirado()
		hide()
		monitoring = false
