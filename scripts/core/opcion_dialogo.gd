extends Resource
class_name OpcionDialogo

## Texto que se muestra en el botón de la opción
@export var texto: String = ""

## Cuánto modifica el estrés al elegir esta opción (positivo = sube, negativo = baja)
@export var delta_estres: float = 5.0
