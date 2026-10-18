extends ClickInteractable
class_name Gato

## Referencia al nodo de animación continua
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D

func al_iniciar() -> void:
	if id.is_empty():
		id = "gato"
	# La animación en loop está corriendo desde el inicio
	if not animated_sprite.is_playing():
		animated_sprite.play("idle")

func on_interaccion_exitosa() -> void:
	# Futuro efecto de la caricia
	# Se permite interactuar con el gato múltiples veces sin que se bloquee
	usada = false
