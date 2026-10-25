extends Node

## Gestor del Estado de la habitación

signal tarea_actualizada(tarea: String)
signal trabajo_completado
signal todas_las_tareas_completadas

# Fase 1: Trabajo pendiente obligatorio
var postits_restantes: int = 4
var computador_apagado: bool = false
var celular_apagado: bool = false

# Fase 2: Tareas secundarias de cuidado
var planta_regada: bool = false
var ropa_ordenada: bool = false
var basura_recogida: bool = false

# Tarea opcional
var reloj_silenciado: bool = false

func _ready() -> void:
	reiniciar_estado()

func reiniciar_estado() -> void:
	postits_restantes = 4
	computador_apagado = false
	celular_apagado = false
	planta_regada = false
	ropa_ordenada = false
	basura_recogida = false
	reloj_silenciado = false

## Comprueba si todo el trabajo pendiente ha sido resuelto
func es_trabajo_completado() -> bool:
	return postits_restantes <= 0 and computador_apagado and celular_apagado

## Comprueba si se pueden realizar tareas secundarias de cuidado
func puede_hacer_secundarias() -> bool:
	return es_trabajo_completado()

## Comprueba si el 100% de las tareas requeridas están completas
func todas_tareas_listas() -> bool:
	return es_trabajo_completado() and planta_regada and ropa_ordenada and basura_recogida

## Modifica el estrés global a través de SistemaEstres
func modificar_estres(delta: float) -> void:
	if not is_inside_tree():
		return
	var tree := get_tree()
	if not tree:
		return
	var sistema = tree.get_first_node_in_group("sistema_estres")
	if sistema and sistema.has_method("modificar_estres"):
		sistema.modificar_estres(delta)

# Registro de tareas 

func marcar_postit_tirado() -> void:
	postits_restantes = max(0, postits_restantes - 1)
	modificar_estres(-6.0) # -6 pts por post-it tirado
	tarea_actualizada.emit("postit")
	if es_trabajo_completado():
		trabajo_completado.emit()

func marcar_computador_apagado() -> void:
	if not computador_apagado:
		computador_apagado = true
		modificar_estres(-25.0) # -25 pts al apagar PC
		tarea_actualizada.emit("computador")
		if es_trabajo_completado():
			trabajo_completado.emit()

func marcar_celular_apagado() -> void:
	if not celular_apagado:
		celular_apagado = true
		modificar_estres(-25.0) # -25 pts al apagar celular
		tarea_actualizada.emit("celular")
		if es_trabajo_completado():
			trabajo_completado.emit()

func marcar_planta_regada() -> void:
	if not planta_regada:
		planta_regada = true
		modificar_estres(-25.0) # -25 pts al regar planta
		tarea_actualizada.emit("planta")
		_comprobar_victoria()

func marcar_ropa_ordenada() -> void:
	if not ropa_ordenada:
		ropa_ordenada = true
		modificar_estres(-25.0) # -25 pts al guardar ropa
		tarea_actualizada.emit("ropa")
		_comprobar_victoria()

func marcar_basura_recogida() -> void:
	if not basura_recogida:
		basura_recogida = true
		modificar_estres(-25.0) # -25 pts al recoger basura
		tarea_actualizada.emit("basura")
		_comprobar_victoria()

func marcar_reloj_silenciado() -> void:
	if not reloj_silenciado:
		reloj_silenciado = true
		modificar_estres(-22.0) # -22 pts al silenciar reloj
		tarea_actualizada.emit("reloj")

func _comprobar_victoria() -> void:
	if todas_tareas_listas():
		todas_las_tareas_completadas.emit()
