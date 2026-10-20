# scenes/ui/sistema_estres.gd
class_name SistemaEstres
extends CanvasLayer

## Nivel actual de estrés (0.0 a 1.0)
@export_range(0.0, 1.0, 0.01) var nivel_estres: float = 0.0:
	set(valor):
		nivel_estres = clamp(valor, 0.0, 1.0)
		_actualizar_estres()

## Porcentaje a partir del cual empiezan a manifestarse el oscurecimiento y el túnel
@export_range(0.0, 1.0, 0.01) var umbral_activacion_estres: float = 0.2:
	set(valor):
		umbral_activacion_estres = clamp(valor, 0.0, 1.0)
		_actualizar_estres()

## Intensidad inicial al superar el umbral libre (70% por defecto)
@export_range(0.0, 1.0, 0.01) var intensidad_inicial: float = 0.7:
	set(valor):
		intensidad_inicial = clamp(valor, 0.0, 1.0)
		_actualizar_estres()

## Nivel de estrés donde se alcanza el 100% de intensidad (90% por defecto)
@export_range(0.0, 1.0, 0.01) var tope_estres_max: float = 0.9:
	set(valor):
		tope_estres_max = clamp(valor, 0.0, 1.0)
		_actualizar_estres()

## Límite máximo de oscuridad general en pantalla al 100% de estrés
@export_range(0.0, 1.0, 0.01) var oscurecimiento_maximo: float = 0.4:
	set(valor):
		oscurecimiento_maximo = clamp(valor, 0.0, 1.0)
		_actualizar_parametros_shader()
		_actualizar_etiquetas_debug()

## Duración en segundos de la transición gradual al cruzar el umbral
@export var duracion_transicion: float = 2.0

# Area de DEBUG 
@onready var efecto_visual: ColorRect = $EfectoVisual
@onready var panel_debug: Control = $PanelDebug
@onready var slider_estres: HSlider = $PanelDebug/MarginContainer/VBoxContainer/FilaEstres/SliderEstres
@onready var label_estres_val: Label = $PanelDebug/MarginContainer/VBoxContainer/FilaEstres/LabelEstresVal
@onready var slider_umbral: HSlider = $PanelDebug/MarginContainer/VBoxContainer/FilaUmbral/SliderUmbral
@onready var label_umbral_val: Label = $PanelDebug/MarginContainer/VBoxContainer/FilaUmbral/LabelUmbralVal
@onready var slider_oscurecimiento: HSlider = $PanelDebug/MarginContainer/VBoxContainer/FilaOscurecimiento/SliderOscurecimiento
@onready var label_oscurecimiento_val: Label = $PanelDebug/MarginContainer/VBoxContainer/FilaOscurecimiento/LabelOscurecimientoVal
@onready var label_estado_efecto: Label = $PanelDebug/MarginContainer/VBoxContainer/LabelEstadoEfecto

# Control de interpolación visual
var intensidad_visual_actual: float = 0.0:
	set(val):
		intensidad_visual_actual = val
		_aplicar_intensidad_shader(intensidad_visual_actual)
		_actualizar_etiquetas_debug()

var tween_transicion: Tween = null
var efecto_activo: bool = false

func _ready() -> void:
	add_to_group("sistema_estres")
	panel_debug.visible = false
	
	# Inicializar valores de controles de debug
	if slider_estres:
		slider_estres.value = nivel_estres * 100.0
		slider_estres.value_changed.connect(_on_slider_estres_changed)
	
	if slider_umbral:
		slider_umbral.value = umbral_activacion_estres * 100.0
		slider_umbral.value_changed.connect(_on_slider_umbral_changed)
		
	if slider_oscurecimiento:
		slider_oscurecimiento.value = oscurecimiento_maximo * 100.0
		slider_oscurecimiento.value_changed.connect(_on_slider_oscurecimiento_changed)
	
	_actualizar_parametros_shader()
	efecto_activo = nivel_estres > umbral_activacion_estres
	intensidad_visual_actual = calcular_intensidad_efecto(nivel_estres)
	_actualizar_etiquetas_debug()

func _unhandled_input(event: InputEvent) -> void:
	# Presionar F1 para ocultar/mostrar el panel de depuración
	if event is InputEventKey and event.pressed and not event.echo:
		if event.keycode == KEY_F1:
			panel_debug.visible = not panel_debug.visible

## Calcula la intensidad visual (0.0 a 1.0) según las curvas de estrés
func calcular_intensidad_efecto(estres: float) -> float:
	# Si está por debajo o igual al umbral libre, no hay efecto
	if estres <= umbral_activacion_estres:
		return 0.0
	
	# Entre el 90% (tope_estres_max) y 100% de estrés, se mantiene al 100%
	if estres >= tope_estres_max:
		return 1.0
	
	# Entre el umbral libre y el 90%, parte en 70% (intensidad_inicial) y sube hasta 100%
	var divisor: float = max(0.001, tope_estres_max - umbral_activacion_estres)
	var factor: float = clamp((estres - umbral_activacion_estres) / divisor, 0.0, 1.0)
	return lerp(intensidad_inicial, 1.0, factor)

func _actualizar_estres() -> void:
	if not is_inside_tree():
		return
	
	var nuevo_activo: bool = nivel_estres > umbral_activacion_estres
	var objetivo: float = calcular_intensidad_efecto(nivel_estres)
	
	if nuevo_activo != efecto_activo:
		efecto_activo = nuevo_activo
		# Gatilla oscurecimiento gradual o retroceso gradual de 2 segundos al cruzar el umbral
		_animar_hacia(objetivo, duracion_transicion)
	else:
		if tween_transicion and tween_transicion.is_running():
			# Si hay una transición en curso, redirige suavemente al nuevo valor
			_animar_hacia(objetivo, duracion_transicion)
		else:
			intensidad_visual_actual = objetivo

func _animar_hacia(destino: float, duracion: float) -> void:
	if tween_transicion and tween_transicion.is_running():
		tween_transicion.kill()
	
	tween_transicion = create_tween()
	tween_transicion.tween_property(self, "intensidad_visual_actual", destino, duracion).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	tween_transicion.finished.connect(_actualizar_etiquetas_debug)

func _aplicar_intensidad_shader(intensidad: float) -> void:
	if efecto_visual and efecto_visual.material:
		var mat = efecto_visual.material as ShaderMaterial
		if mat:
			mat.set_shader_parameter("intensidad_efecto", intensidad)

func _actualizar_parametros_shader() -> void:
	if efecto_visual and efecto_visual.material:
		var mat = efecto_visual.material as ShaderMaterial
		if mat:
			mat.set_shader_parameter("oscurecimiento_maximo", oscurecimiento_maximo)

func _actualizar_etiquetas_debug() -> void:
	# Actualizar etiquetas del panel de debug
	if label_estres_val:
		label_estres_val.text = "%d%%" % int(round(nivel_estres * 100.0))
	if label_umbral_val:
		label_umbral_val.text = "%d%%" % int(round(umbral_activacion_estres * 100.0))
	if label_oscurecimiento_val:
		label_oscurecimiento_val.text = "%d%%" % int(round(oscurecimiento_maximo * 100.0))
		
	if label_estado_efecto:
		if tween_transicion and tween_transicion.is_running():
			label_estado_efecto.text = "Transición en curso... (%d%%)" % int(round(intensidad_visual_actual * 100.0))
			label_estado_efecto.modulate = Color(1.0, 0.8, 0.4)
		elif intensidad_visual_actual <= 0.001:
			label_estado_efecto.text = "Efecto: Inactivo (Estrés <= Umbral %d%%)" % int(round(umbral_activacion_estres * 100.0))
			label_estado_efecto.modulate = Color(0.7, 0.9, 0.7)
		elif nivel_estres >= tope_estres_max:
			label_estado_efecto.text = "Efecto: Máximo 100% (Estrés >= %d%%)" % int(round(tope_estres_max * 100.0))
			label_estado_efecto.modulate = Color(1.0, 0.3, 0.3)
		else:
			label_estado_efecto.text = "Efecto: Activo (Intensidad %d%%)" % int(round(intensidad_visual_actual * 100.0))
			label_estado_efecto.modulate = Color(1.0, 0.6, 0.6)

func _on_slider_estres_changed(val: float) -> void:
	nivel_estres = val / 100.0

func _on_slider_umbral_changed(val: float) -> void:
	umbral_activacion_estres = val / 100.0

func _on_slider_oscurecimiento_changed(val: float) -> void:
	oscurecimiento_maximo = val / 100.0

## Métodos públicos para controlar el estrés desde el juego
func set_estres(valor: float) -> void:
	nivel_estres = valor
	if slider_estres:
		slider_estres.set_value_no_signal(nivel_estres * 100.0)

func modificar_estres(delta: float) -> void:
	set_estres(nivel_estres + delta)

func get_estres() -> float:
	return nivel_estres
