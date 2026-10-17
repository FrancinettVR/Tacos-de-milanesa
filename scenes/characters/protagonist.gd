extends CharacterBody2D
class_name Protagonist

## Velocidad 
@export var speed: float = 400.0

## Margen para considerar que el personaje llegó a su destino
@export var stop_threshold: float = 6.0

## Guarda al personaje
@onready var visual: Node2D = $Visual
## Guarda la cámara
@onready var camera: Camera2D = $Camera2D

## Guarda posición horizontal y fija eje Y
var target_x: float = 0.0
var fixed_y: float = 0.0


## Función de ejecución inicial y única
## Guarda la pos inicial del personaje y fija el eje Y
func _ready() -> void:
	fixed_y = position.y
	target_x = position.x

## Guarda si el personaje se sigue moviendo o está en destino
var is_moving: bool = false

## Función que procesa el movimiento del personaje
func _physics_process(_delta: float) -> void:
	if is_moving:
		var distance_x: float = target_x - position.x
		
		# Si aún no llega
		if abs(distance_x) > stop_threshold:
			var direction: float = sign(distance_x)
			velocity.x = direction * speed
			
			# Orientar la dirección de mirada
			if direction > 0:
				visual.scale.x = 1.0 # Mirar a la derecha
			elif direction < 0:
				visual.scale.x = -1.0 # Mirar a la izquierda
			#Aqui se mueve	
			move_and_slide()
			
			# Por si acaso
			position.y = fixed_y
		else:
			# Llegó al destino
			position.x = target_x
			position.y = fixed_y
			velocity.x = 0.0
			is_moving = false

## Función pública para ordenar a la protagonista caminar hacia una coordenada X
func walk_to(destination_x: float) -> void:
	# Evitamos que camine fuera de los límites de la habitación (con margen de 60 px)
	target_x = clamp(destination_x, 60.0, 5700.0)
	is_moving = true
