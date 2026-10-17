extends ClickInteractable

var textura_seca = preload("res://assets/art/interactables/placeholders/spr_planta_seca.png")
var textura_feliz = preload("res://assets/art/interactables/placeholders/spr_planta_feliz.png")

func al_iniciar() -> void:
	sprite.texture = textura_seca

func on_interaccion_exitosa() -> void:
	sprite.texture = textura_feliz

# Esta función la va a llamar la Botella
func regar() -> void:
	intentar_interactuar()
