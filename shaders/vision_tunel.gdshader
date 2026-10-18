shader_type canvas_item;

// Intensidad del efecto (0.0 = sin efecto, 1.0 = efecto al máximo)
uniform float intensidad_efecto : hint_range(0.0, 1.0) = 0.0;

// Tope de oscurecimiento (ej. 1.0 es negro absoluto)
uniform float oscurecimiento_maximo : hint_range(0.0, 1.0) = 0.4;

// Color del oscurecimiento
uniform vec4 color_efecto : source_color = vec4(0.0, 0.0, 0.0, 1.0);

// Radio interior (zona despejada) y exterior (zona completamente oscura)
uniform float radio_tunel_min : hint_range(0.05, 1.0) = 0.2;
uniform float radio_tunel_max : hint_range(0.1, 2.0) = 0.9;
uniform float suavidad_borde : hint_range(0.05, 1.0) = 0.4;

void fragment() {
	if (intensidad_efecto <= 0.001) {
		COLOR = vec4(color_efecto.rgb, 0.0);
	} else {
		// Centrar coordenadas en (0, 0)
		vec2 uv = UV - vec2(0.5);
		
		// Proporción levemente horizontal para visión panorámica
		float dist = length(vec2(uv.x * 0.9, uv.y));
		
		// El túnel se contrae a medida que aumenta la intensidad del efecto
		float inner = mix(radio_tunel_max, radio_tunel_min, intensidad_efecto);
		float outer = inner + mix(suavidad_borde, 0.2, intensidad_efecto);
		
		// Bordes
		float tunel = smoothstep(inner, outer, dist);
		
		// Oscurecimiento
		float oscurecimiento_base = intensidad_efecto * (oscurecimiento_maximo * 0.5);
		
		// Combinar oscurecimiento con visión túnel
		float alpha_final = oscurecimiento_base + (tunel * (oscurecimiento_maximo - oscurecimiento_base));
		alpha_final = clamp(alpha_final, 0.0, oscurecimiento_maximo);
		
		COLOR = vec4(color_efecto.rgb, alpha_final);
	}
}
