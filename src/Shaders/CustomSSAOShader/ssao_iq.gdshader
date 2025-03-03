shader_type spatial;
render_mode unshaded;

// The MIT License
// Copyright © 2014 Inigo Quilez
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions: The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software. THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

uniform sampler2D DEPTH_TEXTURE: hint_depth_texture;
uniform sampler2D SCREEN_TEXTURE: hint_screen_texture;
uniform sampler2D noise: source_color;
uniform float power_of_ao: hint_range(1.0, 8.0, 0.1) = 8.0;

void vertex() {
	
}

void fragment() {
	// sample zbuffer (in linear eye space) at the current shading point	
	float zr = 1.0-texture(DEPTH_TEXTURE, SCREEN_UV ).r;

    // sample neighbor pixels
	float ao = 0.0;
	for( int i=0; i<8; i++ )
	{
        // get a random 2D offset vector
        vec2 off = -1.0 + 2.0 * texture(noise, (FRAGCOORD.xy + 23.71*float(i))/UV ).xz;	
        // sample the zbuffer at a neightbor pixel (in a 16 pixel radious)        		
        float z = 1.0-texture( DEPTH_TEXTURE, (FRAGCOORD.xy + floor(off*16.0))/VIEWPORT_SIZE ).x;
        // accumulate occlusion if difference is less than 0.1 units		
		ao += clamp( (zr-z)/0.1, 0.0, 1.0) * power_of_ao;
	}
    // average down the occlusion	
    ao = clamp( 1.0 - ao/8.0, 0.0, 1.0 );
	
	//vec3 col = 
	vec3 col = vec3(ao);
	col *= texture(SCREEN_TEXTURE, SCREEN_UV).rgb;
	
	ALBEDO = col;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
