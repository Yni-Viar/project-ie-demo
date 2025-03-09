shader_type spatial;
render_mode unshaded;
// Made by Yni.
// License - CC0.

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;
uniform vec3 white: source_color = vec3(0.5);
uniform vec3 black: source_color = vec3(0.0);
uniform float transition: hint_range(0.0, 0.25, 0.001) = 0.125;

void vertex() {
	// Called for every vertex the material is visible on.
}

void fragment() {
	vec3 tex = texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	if (tex.r > transition || tex.g > transition || tex.b > transition){
		ALBEDO = white;
	}
	else {
		ALBEDO = black;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
