shader_type spatial;

//Made by Yni. License - CC0.

uniform sampler2D texture_a: source_color;
uniform sampler2D texture_b: source_color;

void fragment() {
	vec4 tex_a = texture(texture_a, UV);
	vec4 tex_b = texture(texture_b, UV);
	ALBEDO = tex_a.rgb + tex_b.rgb;
}
