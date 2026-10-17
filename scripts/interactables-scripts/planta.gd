extends Area2D

@export var regada: bool = false

@onready var sprite: Sprite2D = $Sprite2D

var textura_seca = preload("res://assets/art/interactables/placeholders/spr_planta_seca.png")
var textura_feliz = preload("res://assets/art/interactables/placeholders/spr_planta_feliz.png")

func _ready() -> void:
	actualizar_sprite()

func regar() -> void:
	regada = true
	actualizar_sprite()
	print("Planta regada")

func actualizar_sprite() -> void:
	if regada:
		sprite.texture = textura_feliz
	else:
		sprite.texture = textura_seca
