extends Interactable
class_name Planta

var textura_seca = preload("res://assets/art/Zona2/Planta2.png")
var textura_feliz = preload("res://assets/art/Zona2/Planta1.png")

@onready var audio_agua: AudioStreamPlayer2D = get_node_or_null("AudioAgua")

func al_iniciar() -> void:
	if id.is_empty():
		id = "planta"
	sprite.texture = textura_feliz if usada else textura_seca

func es_disponible() -> bool:
	return GameManager.puede_hacer_secundarias()

func _ready() -> void:
	super._ready()
	input_event.connect(_on_input_event)

## Si el jugador hace clic en la planta seca
func _on_input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		viewport.set_input_as_handled()
		if not es_disponible():
			if DialogueUi:
				DialogueUi.mostrar_pensamiento("No puedo ocuparme de esto con tanto trabajo pendiente")
			return
		if not usada:
			if DialogueUi:
				DialogueUi.mostrar_pensamiento("La planta está marchita... necesita agua de la botella.")

func on_interaccion_exitosa() -> void:
	sprite.texture = textura_feliz
	if audio_agua:
		audio_agua.play()
	GameManager.marcar_planta_regada()

## Esta función va a llamar a la Botella 
func regar() -> void:
	intentar_interactuar()
