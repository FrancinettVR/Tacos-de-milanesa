extends ClickInteractable
class_name Gato

## Referencia al nodo de animación continua
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var audio_ronroneo: AudioStreamPlayer2D = get_node_or_null("AudioRonroneo")
@onready var audio_maullido: AudioStreamPlayer2D = get_node_or_null("AudioMaullido")

func al_iniciar() -> void:
	if id.is_empty():
		id = "gato"
	# La animación en loop está corriendo desde el inicio
	if not animated_sprite.is_playing():
		animated_sprite.play("idle")

func on_interaccion_exitosa() -> void:
	# Se permite interactuar con el gato múltiples veces sin que se bloquee
	usada = false
	
	# Evitar solapamiento
	if (audio_ronroneo and audio_ronroneo.is_playing()) or (audio_maullido and audio_maullido.is_playing()):
		return
	
	GameManager.modificar_estres(-21.0)
	
	# random entre ronroneo y maullido
	if randf() < 0.5:
		if audio_ronroneo:
			audio_ronroneo.play()
	else:
		if audio_maullido:
			audio_maullido.play()
