//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float flashFac;

void main()
{
	vec4 col = texture2D(gm_BaseTexture, v_vTexcoord);
	col.rgb = mix(col.rgb, vec3(1.), flashFac);
	
    gl_FragColor = col;
}
