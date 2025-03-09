shader_type canvas_item;

uniform vec2 speed = vec2(0.01, -0.07);
uniform bool active = true;

void fragment() {
	vec2 uv_offset = UV;
	if (active){
		uv_offset +=  speed * TIME;
	}

	vec4 screen_color = texture(TEXTURE, fract(uv_offset));

	COLOR = screen_color;
}
