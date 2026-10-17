extends Node

# Se emite cuando un interactuable completa su acción exitosamente
signal interaccion_completada(id: String)

# Se emite cuando se intenta interactuar pero está bloqueado
signal interaccion_bloqueada(id: String)
