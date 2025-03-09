shader_type canvas_item;

uniform vec2 speed = vec2(0, -1);

void fragment() {
	vec2 uv_offset = UV + speed * TIME;
	vec4 screen_color = texture(TEXTURE, fract(uv_offset));

	COLOR = screen_color;
}
