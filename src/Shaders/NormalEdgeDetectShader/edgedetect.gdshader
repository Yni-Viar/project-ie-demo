shader_type spatial;
render_mode unshaded;
/*
	Made by nuzcraft
	The shader code and all code snippets in this post are under CC0 license
	and can be used freely without the author's permission.
	
	Edited by Yni for simplifying the shader.
*/
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
//uniform sampler2D NORMAL_TEXTURE : hint_normal_roughness_texture, filter_linear_mipmap;

//uniform float edge_threshold = 0.2;
//uniform vec3 line_color: source_color = vec3(0.043, 0.282, 0.467);
//uniform vec3 background_color: source_color = vec3(0.408, 0.969, 0.694);

const mat2 robert_y = mat2(
	vec2(0.0, 1.0),
	vec2(-1.0, 0.0)
);

const mat2 robert_x = mat2(
	vec2(1.0, 0.0),
	vec2(0.0, -1.0)
);

void vertex(){
	POSITION = vec4(VERTEX, 1.0);
}

void fragment() {
	vec2 uv = SCREEN_UV;
	vec4 screen_color = texture(SCREEN_TEXTURE, uv);
	//vec3 normal = texture(NORMAL_TEXTURE, uv).rgb;
	//normal = normal * 2.0 - 1.0;
	vec2 offset = 1.0 / VIEWPORT_SIZE;

	vec3 nw = texture(SCREEN_TEXTURE, uv + vec2(-offset.x, -offset.y)).rgb;
	vec3 ne = texture(SCREEN_TEXTURE, uv + vec2(offset.x, -offset.y)).rgb;
	vec3 sw = texture(SCREEN_TEXTURE, uv + vec2(-offset.x, offset.y)).rgb;
	vec3 se = texture(SCREEN_TEXTURE, uv + vec2(offset.x, offset.y)).rgb;

	mat2 surrounding_pixels = mat2(
		vec2(length(nw), length(ne)),
		vec2(length(sw), length(se))
	);

	float edge_x = dot(robert_x[0], surrounding_pixels[0]) + dot(robert_x[1], surrounding_pixels[1]);
	float edge_y = dot(robert_y[0], surrounding_pixels[0]) + dot(robert_y[1], surrounding_pixels[1]);

	float edge = sqrt(pow(edge_x, 2.0)+pow(edge_y, 2.0));

	ALBEDO = vec3(edge);
}
