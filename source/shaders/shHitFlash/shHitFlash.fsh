//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float flashFac;

void main()
{
	vec4 col = vec4(0.);
	col.rgb = mix(vec3(1., .0, .0), vec3(1.), flashFac);
	col.a = texture2D(gm_BaseTexture, v_vTexcoord).a;
	
    gl_FragColor = col;
}
