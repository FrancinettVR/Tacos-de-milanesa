extends Interactable

var textura_vacio = preload("res://assets/art/interactables/placeholders/spr_cesto_vacio.png")
var textura_lleno = preload("res://assets/art/interactables/placeholders/spr_cesto_lleno.png")

func al_iniciar() -> void:
	sprite.texture = textura_vacio

func on_interaccion_exitosa() -> void:
	sprite.texture = textura_lleno
