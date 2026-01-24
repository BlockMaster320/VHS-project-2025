//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float time;

float rand(float n){return fract(sin(n) * 43758.5453123);}


void main()
{
	vec4 col = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	//col.rgb = pow(col.rgb, vec3(2.2));
	col.rgb = pow(col.rgb, vec3(.6));
	//col.rgb += .5;
	col.rgb = 1.-col.rgb;
	col.rgb *= .9;
	col.rgb = 1.-col.rgb;
	col.rgb += vec3(rand((time) + v_vTexcoord.x * 10.123 + v_vTexcoord.y*3516.126)) * .05;
	col.rgb *= v_vColour.a;
	
	//col.rgb *= vec3(1., .9, .8);
    gl_FragColor = col;
}
