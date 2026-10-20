extends ClickInteractable
class_name Cuadro

var textura_torcido = preload("res://assets/art/Zona1/Cuadro.png")
var textura_recto = preload("res://assets/art/Zona1/Cuadro2.png")

var recto: bool = false

func al_iniciar() -> void:
	if id.is_empty():
		id = "cuadro"
	sprite.texture = textura_torcido

func on_interaccion_exitosa() -> void:
	recto = not recto
	usada = false # permite volver a clickear (toggle)
	sprite.texture = textura_recto if recto else textura_torcido
