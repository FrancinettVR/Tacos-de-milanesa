extends Area2D

@export var planta: Node

@onready var sprite: Sprite2D = $Sprite2D

var textura_llena = preload("res://assets/art/interactables/placeholders/spr_botella_llena.png")
var textura_vacia = preload("res://assets/art/interactables/placeholders/spr_botella_vacia.png")

var usada: bool = false

func _ready() -> void:
	input_event.connect(_on_input_event)
	actualizar_sprite()

func _on_input_event(viewport, event, shape_idx) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		regar_planta()

func regar_planta() -> void:
	if usada:
		return
	if planta:
		planta.regar()
		usada = true
		actualizar_sprite()

func actualizar_sprite() -> void:
	if usada:
		sprite.texture = textura_vacia
	else:
		sprite.texture = textura_llena
