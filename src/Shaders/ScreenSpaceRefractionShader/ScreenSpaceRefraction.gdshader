shader_type spatial;

uniform vec3 albedo : source_color;
uniform sampler2D normalmap;

uniform float alpha : hint_range(0.0, 1.0, 0.01) = 0.8;
uniform float refraction_strength : hint_range(0.0, 8.0, 0.001) = 0.5;
uniform sampler2D screen_texture : hint_screen_texture;

uniform sampler2D depth_texture : hint_depth_texture;

uniform bool is_depth_based = false;

vec2 refract_uv(vec2 uv, float strength, vec3 normal){
	float strength1 = strength * (is_depth_based ? pow(uv.y, 4.0) * 5.0 : 1.0);
	uv += strength1 * length(normal) - strength1 * 1.2;
	return uv;
}

void fragment() {
	vec3 nmap = texture(normalmap, UV).rgb;
	ALBEDO = mix(albedo, texture(screen_texture, refract_uv(SCREEN_UV, refraction_strength, nmap)).rgb, 1.0 - alpha);
}