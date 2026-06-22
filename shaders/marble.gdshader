shader_type spatial;

uniform vec3 color_a : source_color = vec3(0.05, 0.3, 0.9);
uniform vec3 color_b : source_color = vec3(0.1, 0.3, 0.7);
uniform vec3 color_c : source_color = vec3(0.2, 0.1, 0.3);

vec3 hash3(vec3 p) {
    p = fract(p * vec3(443.897, 397.297, 491.187));
    p += dot(p.zxy, p.yxz + 19.19);
    return fract(vec3(p.x * p.y, p.z * p.x, p.y * p.z));
}

float noise(vec3 p) {
    vec3 i = floor(p);
    vec3 f = fract(p);
    vec3 u = f * f * (3.0 - 2.0 * f);
    return mix(mix(mix(hash3(i).x, hash3(i+vec3(1,0,0)).x, u.x),
                   mix(hash3(i+vec3(0,1,0)).x, hash3(i+vec3(1,1,0)).x, u.x), u.y),
               mix(mix(hash3(i+vec3(0,0,1)).x, hash3(i+vec3(1,0,1)).x, u.x),
                   mix(hash3(i+vec3(0,1,1)).x, hash3(i+vec3(1,1,1)).x, u.x), u.y), u.z);
}

float fbm(vec3 p) {
    float v = 0.0; float a = 0.5;
    for (int i = 0; i < 4; i++) {
        v += a * noise(p); p *= 2.1; a *= 0.5;
    }
    return v;
}

void fragment() {
	vec3 p = VERTEX * 3.0;
	
	float swirl = fbm(p + vec3(fbm(p+vec3(1.7, 9.2, 5.4))));
	float band = fract(swirl * 3.0 + p.y * 0.5);
	
	vec3 color;
	if(band < 0.33){
		color = mix(color_a, color_b, band * 3.0);
	}
	else if(band < 0.66)
	{
		color = mix(color_b, color_c, (band-0.33) * 3.0);
	}
	else{
		color = mix(color_c, color_a, (band-0.66) * 3.0);
	}
	
	ALBEDO = color;
	ROUGHNESS = 0.05;
	SPECULAR = 1.0;
	METALLIC = 0.0;
	float fresnel = pow(1.0 - dot(NORMAL, VIEW), 3.0);
	ALBEDO = mix(ALBEDO, vec3(1.0), fresnel*3.0);
}