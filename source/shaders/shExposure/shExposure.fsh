//
// Simple passthrough fragment shader
//
varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float time;
uniform vec2 texSize;
uniform sampler2D lightmap;

float MGSVtonemapf(float lum)
{
	float a = .6;
	float b = .4533;
    return lum > .8 ? min(1.,.8+.2-(.2*.2)/(lum-.8+.2)) : lum;
}

vec3 MGSVtonemap(vec3 col)
{
    return vec3(MGSVtonemapf(col.r),MGSVtonemapf(col.g),MGSVtonemapf(col.b));
}

vec3 Sigmoid(vec3 col)
{
    col = pow(col, vec3(1.05));
    return pow(col / (col + .4155), vec3(1.27));
}

// Source: Smoothstep Wikipedia
float smootherstep(float val)
{
	val = clamp(val, 0., 1.);
	return val * val * val * (val * (6.0 * val - 15.0) + 10.0);
}

vec3 contrast(vec3 col, float a)
{
	vec3 sigmoid = vec3(smootherstep(col.r), smootherstep(col.g), smootherstep(col.b));
	return mix(col, sigmoid, a);
}

void main()
{
	vec4 col = v_vColour * texture2D( gm_BaseTexture, v_vTexcoord );
	
	float darkAreas = 1. - texture2D(lightmap, v_vTexcoord*(480./500.) + vec2(10./500.,3./290.)).r;	// Kinda broken but welp
	
	col.rgb = pow(col.rgb, vec3(1.5));
	col.rgb *= darkAreas*2. + 1.;
	//col.rgb += (1.-darkAreas) * .02;
	col.rgb = MGSVtonemap(col.rgb);
	col.rgb = pow(col.rgb, vec3(1./1.5));
	col.rgb = contrast(col.rgb, darkAreas*.5);
	col.rgb = mix(col.rgb, pow(col.rgb, vec3(1.1)), darkAreas);
	
    gl_FragColor = col;
}
