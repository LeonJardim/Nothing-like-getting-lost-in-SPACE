shader_type canvas_item;

uniform bool ship_dodge = false;

void fragment() {
	float result;
	vec4 tex = texture(TEXTURE,UV);
	if (ship_dodge){
		float fade = sin(TIME * 6.0);
		fade = 0.3 + 0.3 * fade;
		result = sin((TIME * 20.0) + (UV.r * 200.0));
		result = fade + (1.0 - fade) * result;
		result = mix(0.0, result, tex.a);
		COLOR.a = result;
	}
}
