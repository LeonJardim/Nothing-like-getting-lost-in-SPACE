shader_type canvas_item;

uniform float speed : hint_range(0.1, 5.0) = 1.0;
uniform float intensity : hint_range(0.0, 0.5) = 0.02;
uniform float randomness : hint_range(0.0, 10.0) = 2.0;
uniform bool active = false;

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	if (active){
		float brightness = dot(color.rgb, vec3(0.333));

		if (brightness > 0.5) {
			float noise = fract(sin(dot(UV, vec2(0.04, 0.05))) * 30.0);
			float pulse = sin(TIME * speed + noise * randomness) * 0.5 + 0.5;

			vec2 uv_offset = (UV - 0.5) * (pulse * intensity);
			color = texture(TEXTURE, UV + uv_offset);
	}}

	COLOR = color;
}
