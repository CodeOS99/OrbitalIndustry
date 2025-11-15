shader_type canvas_item;

// adj
uniform float scanline_intensity: hint_range(.0, 1) = .3;
uniform float noise_amount: hint_range(.0, .2) = .05;
uniform float vignette_strength: hint_range(.0, 1) = .5;
uniform float effect_opactiy: hint_range(.0, 1.) = 1.;
uniform float green_intensity: hint_range(.0, 1.) = .5;
uniform sampler2D screen_texture: hint_screen_texture, filter_linear_mipmap;

float random(vec2 co) {
	return fract(sin(dot(co, vec2(12.9898, 78.233))) * 43758.5453123);
}

void fragment()  {
	vec4 screen_color = texture(screen_texture, SCREEN_UV);
	
	float gray = dot(screen_color.rgb, vec3(.299, .587, .114));
	
	float scanlines = sin(SCREEN_UV.y*800.)*.5+.5;
	gray *= 1.0 - (scanlines * scanline_intensity);
	
	float noise = random(SCREEN_UV + vec2(TIME*2.0, TIME));
	gray = mix(gray, noise, noise_amount);
	
	vec2 center = SCREEN_UV - vec2(.5);
	float dist = length(center);
	float vignette = 1. - (dist*vignette_strength);
	gray *= vignette;
	
	vec3 final_col = vec3(gray*(1.-green_intensity), gray, gray*(1.-green_intensity));
	
	vec3 result = mix(screen_color.rgb, final_col, effect_opactiy);
	
	COLOR = vec4(result, 1.0);
}
