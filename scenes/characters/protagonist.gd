extends CharacterBody2D
class_name Protagonist

## Velocidad 
@export var speed: float = 400.0

## Margen para considerar que el personaje llegó a su destino
@export var stop_threshold: float = 6.0

## Nodo visual animado
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
## Compatibilidad
@onready var visual: Node2D = get_node_or_null("Visual")
## Guarda la cámara
@onready var camera: Camera2D = $Camera2D

## Guarda posición horizontal y fija eje Y
var target_x: float = 0.0
var fixed_y: float = 0.0

## Última dirección hacia la que miraba (true = derecha, false = izquierda)
var mirando_derecha: bool = true

## Guarda si el personaje se sigue moviendo o está en destino
var is_moving: bool = false

## Función de ejecución inicial y única
## Guarda la pos inicial del personaje y fija el eje Y
func _ready() -> void:
	add_to_group("protagonista")
	fixed_y = position.y
	target_x = position.x
	# Estado inicial en reposo mirando a la derecha
	if animated_sprite:
		animated_sprite.play("reposo_derecha")

## Función que procesa el movimiento del personaje
func _physics_process(_delta: float) -> void:
	if is_moving:
		var distance_x: float = target_x - position.x
		
		# Si aún no llega
		if abs(distance_x) > stop_threshold:
			var direction: float = sign(distance_x)
			velocity.x = direction * speed
			
			# Orientar la dirección con animaciones dedicadas:
			if direction > 0:
				mirando_derecha = true
				if animated_sprite:
					animated_sprite.play("caminar_derecha")
				# [Obsoleto]:
				# Se usan animaciones dedicadas (Derecha / Izquierda) en lugar de voltear por escala
				# if visual: visual.scale.x = 1.0
			elif direction < 0:
				mirando_derecha = false
				if animated_sprite:
					animated_sprite.play("caminar_izquierda")
				# [Obsoleto]:
				# Se usan animaciones dedicadas (Derecha / Izquierda) en lugar de voltear por escala
				# if visual: visual.scale.x = -1.0
				
			# Aqui se mueve	
			move_and_slide()
			
			# Por si acaso
			position.y = fixed_y
		else:
			# Llegó al destino
			position.x = target_x
			position.y = fixed_y
			velocity.x = 0.0
			is_moving = false
			
			# Transición a la pose de reposo según la última dirección
			if animated_sprite:
				if mirando_derecha:
					animated_sprite.play("reposo_derecha")
				else:
					animated_sprite.play("reposo_izquierda")

## Función pública para ordenar a la protagonista caminar hacia una coordenada X
func walk_to(destination_x: float) -> void:
	# Evitamos que camine fuera de los límites de la habitación (con margen de 60 px)
	target_x = clamp(destination_x, 60.0, 5700.0)
	is_moving = true

## Evita que camine si se abre el dialogo
func stop() -> void:
	is_moving = false
	velocity.x = 0.0
	if animated_sprite:
		if mirando_derecha:
			animated_sprite.play("reposo_derecha")
		else:
			animated_sprite.play("reposo_izquierda")
