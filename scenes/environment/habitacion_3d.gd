class_name Habitacion3D
extends Node3D

## Configuración de iluminación
@export var modo_sin_luz: bool = true:
	set(val):
		modo_sin_luz = val
		if is_node_ready():
			_actualizar_iluminacion()

## Configuración de cámara
@export var usar_camara_ortografica: bool = true:
	set(val):
		usar_camara_ortografica = val
		if is_node_ready():
			_configurar_camara()

@export var cam_altura_y: float = 0.54:
	set(val):
		cam_altura_y = val
		if is_node_ready() and cam3d:
			cam3d.position.y = cam_altura_y

@export var cam_distancia_z: float = 2.5:
	set(val):
		cam_distancia_z = val
		if is_node_ready() and cam3d:
			cam3d.position.z = cam_distancia_z

@export var cam_orto_size: float = 1.08:
	set(val):
		cam_orto_size = val
		if is_node_ready() and cam3d and usar_camara_ortografica:
			cam3d.size = cam_orto_size

@export var cam_persp_fov: float = 50.0:
	set(val):
		cam_persp_fov = val
		if is_node_ready() and cam3d and not usar_camara_ortografica:
			cam3d.fov = cam_persp_fov

@onready var cam3d: Camera3D = $Camera3D
@onready var luz_direccional: DirectionalLight3D = $DirectionalLight3D
@onready var world_env: WorldEnvironment = $WorldEnvironment

var _materiales: Array[StandardMaterial3D] = []

func _ready() -> void:
	_configurar_materiales()
	_configurar_camara()
	_actualizar_iluminacion()

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F2:
			modo_sin_luz = not modo_sin_luz
			print("[Fondo 3D] Modo iluminación: %s (F2)" % ("Sin Luz (Unshaded)" if modo_sin_luz else "Con Iluminación (PBR)"))
		elif event.keycode == KEY_F3:
			cam_altura_y -= 0.02
			print("[Fondo 3D] cam_altura_y: %.3f (F3/F4 ajusta altura)" % cam_altura_y)
		elif event.keycode == KEY_F4:
			cam_altura_y += 0.02
			print("[Fondo 3D] cam_altura_y: %.3f (F3/F4 ajusta altura)" % cam_altura_y)
		elif event.keycode == KEY_F5:
			cam_orto_size -= 0.02
			print("[Fondo 3D] cam_orto_size: %.3f (F5/F6 ajusta tamaño)" % cam_orto_size)
		elif event.keycode == KEY_F6:
			cam_orto_size += 0.02
			print("[Fondo 3D] cam_orto_size: %.3f (F5/F6 ajusta tamaño)" % cam_orto_size)

func _configurar_materiales() -> void:
	_materiales.clear()
	
	# 1. Pared
	var mat_pared := StandardMaterial3D.new()
	mat_pared.resource_name = "Mat_Pared"
	mat_pared.albedo_texture = load("res://assets/art/Arte 3D/texturas_substance/pared/pared_DefaultMaterial_BaseColor.png")
	mat_pared.normal_enabled = true
	mat_pared.normal_texture = load("res://assets/art/Arte 3D/texturas_substance/pared/pared_DefaultMaterial_Normal.png")
	mat_pared.roughness = 0.8
	_asignar_material("Pared", mat_pared)
	_materiales.append(mat_pared)
	
	# 2. Piso / Suelo
	var mat_piso := StandardMaterial3D.new()
	mat_piso.resource_name = "Mat_Piso"
	mat_piso.albedo_texture = load("res://assets/art/Arte 3D/texturas_substance/suelo/entorno_largo_DefaultMaterial_BaseColor.png")
	mat_piso.normal_enabled = true
	mat_piso.normal_texture = load("res://assets/art/Arte 3D/texturas_substance/suelo/entorno_largo_DefaultMaterial_Normal.png")
	mat_piso.roughness = 0.6
	_asignar_material("Piso", mat_piso)
	_materiales.append(mat_piso)
	
	# 3. Maceta
	var mat_maceta := StandardMaterial3D.new()
	mat_maceta.resource_name = "Mat_Maceta"
	mat_maceta.albedo_texture = load("res://assets/art/Arte 3D/texturas_substance/maceta/maceta_DefaultMaterial_BaseColor.png")
	mat_maceta.normal_enabled = true
	mat_maceta.normal_texture = load("res://assets/art/Arte 3D/texturas_substance/maceta/maceta_DefaultMaterial_Normal.png")
	mat_maceta.roughness = 0.5
	_asignar_material("Maceta", mat_maceta)
	_materiales.append(mat_maceta)
	
	# 4. Sillón
	var mat_sillon := StandardMaterial3D.new()
	mat_sillon.resource_name = "Mat_Sillon"
	mat_sillon.albedo_texture = load("res://assets/art/Arte 3D/texturas_substance/sillon/sillon_DefaultMaterial_BaseColor.png")
	mat_sillon.normal_enabled = true
	mat_sillon.normal_texture = load("res://assets/art/Arte 3D/texturas_substance/sillon/sillon_DefaultMaterial_Normal.png")
	mat_sillon.roughness = 0.7
	_asignar_material("Sillon", mat_sillon)
	_materiales.append(mat_sillon)
	
	# 5. Cama
	var mat_cama := StandardMaterial3D.new()
	mat_cama.resource_name = "Mat_Cama"
	var cama_tex_path := "res://assets/art/Arte 3D/texturas_substance/cama/cama_DefaultMaterial_BaseColor.png"
	if ResourceLoader.exists(cama_tex_path):
		mat_cama.albedo_texture = load(cama_tex_path)
		var cama_norm_path := "res://assets/art/Arte 3D/texturas_substance/cama/cama_DefaultMaterial_Normal.png"
		if ResourceLoader.exists(cama_norm_path):
			mat_cama.normal_enabled = true
			mat_cama.normal_texture = load(cama_norm_path)
	else:
		# Usa los colores de vértices del FBX (sábanas rosa, almohadas rojas, marco verde)
		mat_cama.vertex_color_use_as_albedo = true
	mat_cama.roughness = 0.8
	_asignar_material("Cama", mat_cama)
	_materiales.append(mat_cama)
	
	# 6. Mueble
	var mat_mueble := StandardMaterial3D.new()
	mat_mueble.resource_name = "Mat_Mueble"
	var mueble_tex_path := "res://assets/art/Arte 3D/texturas_substance/mueble/mueble_DefaultMaterial_BaseColor.png"
	if ResourceLoader.exists(mueble_tex_path):
		mat_mueble.albedo_texture = load(mueble_tex_path)
		var mueble_norm_path := "res://assets/art/Arte 3D/texturas_substance/mueble/mueble_DefaultMaterial_Normal.png"
		if ResourceLoader.exists(mueble_norm_path):
			mat_mueble.normal_enabled = true
			mat_mueble.normal_texture = load(mueble_norm_path)
	else:
		# Tono madera cálida mientras se agregan las texturas de Substance
		mat_mueble.albedo_color = Color(0.62, 0.45, 0.32, 1.0)
	mat_mueble.roughness = 0.6
	_asignar_material("Mueble", mat_mueble)
	_materiales.append(mat_mueble)

func _asignar_material(node_name: String, mat: StandardMaterial3D) -> void:
	var n: Node = find_child(node_name, true, false)
	if not n:
		return
	var mi := _buscar_mesh_instance(n)
	if mi:
		mi.material_override = mat

func _buscar_mesh_instance(node: Node) -> MeshInstance3D:
	if node is MeshInstance3D:
		return node
	for child in node.get_children():
		var found := _buscar_mesh_instance(child)
		if found:
			return found
	return null

func _configurar_camara() -> void:
	if not cam3d:
		return
	cam3d.position.y = cam_altura_y
	cam3d.position.z = cam_distancia_z
	if usar_camara_ortografica:
		cam3d.projection = Camera3D.PROJECTION_ORTHOGONAL
		cam3d.size = cam_orto_size
	else:
		cam3d.projection = Camera3D.PROJECTION_PERSPECTIVE
		cam3d.fov = cam_persp_fov

func _actualizar_iluminacion() -> void:
	var mode := BaseMaterial3D.SHADING_MODE_UNSHADED if modo_sin_luz else BaseMaterial3D.SHADING_MODE_PER_PIXEL
	for mat in _materiales:
		mat.shading_mode = mode
	
	if luz_direccional:
		luz_direccional.visible = not modo_sin_luz

## Sincroniza la posición X según el progreso normalizado t [0.0, 1.0] de la habitación 2D
func sincronizar_camara_progreso(t: float) -> void:
	if not cam3d:
		return
	var half_w: float = (cam3d.size * (16.0 / 9.0)) / 2.0
	var x_min: float = -2.88 + half_w
	var x_max: float = 2.88 - half_w
	cam3d.position.x = lerp(x_min, x_max, clampf(t, 0.0, 1.0))

## Sincronización directa en X (mantenida por compatibilidad)
func sincronizar_camara_x(pos_x_3d: float) -> void:
	if cam3d:
		cam3d.position.x = pos_x_3d
