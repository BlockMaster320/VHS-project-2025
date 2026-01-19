//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float time;

float MGSVtonemapf(float lum)
{
    return lum > .8 ? min(1.,.8+.2-(.2*.2)/(lum-.8+.2)) : lum;
}

vec3 MGSVtonemap(vec3 col)
{
    return vec3(MGSVtonemapf(col.r),MGSVtonemapf(col.g),MGSVtonemapf(col.b));
}

void main()
{
	vec4 col = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	
	col.rgb *= 1.2;
	col.rgb = MGSVtonemap(col.rgb);
	
    gl_FragColor = col;
}
