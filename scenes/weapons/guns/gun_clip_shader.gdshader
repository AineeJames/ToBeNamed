shader_type canvas_item;

// Number of bullets or segments in the circular clip
uniform float inner_radius: hint_range(0.0, 0.5, 0.01) = 0.4;
uniform float outer_radius: hint_range(0.0, 0.5, 0.01) = 0.5;
uniform int num_bullets = 7;
uniform int clip_size = 10;
uniform vec4 circle_color: source_color = vec4(1.0, 1.0, 1.0, 0.8);
uniform vec4 circle_reloading_color: source_color = vec4(1.0, 1.0, 1.0, 0.3);
uniform vec4 circle_bg_color: source_color = vec4(1.0, 1.0, 1.0, 0.1);
uniform float margin: hint_range(0.0, 1.0, 0.0001) = 0.3; 
uniform bool is_reloading;

void fragment() {
	
	vec2 center = SCREEN_PIXEL_SIZE / 2.0 + 0.5;
	float dist = distance(center, UV);
	vec2 delta = UV - center;
	
	float angle = atan(delta.y / delta.x);
	if (delta.x < 0.0) {
		angle += PI;
	} else if (delta.y < 0.0) {
		angle += 2.0 * PI;
	}
	
	float bullet_to_size_ratio = float(num_bullets) / float(clip_size);
	
	// within circle
	if (dist > inner_radius && dist < outer_radius) {
		
		float segment_angle = (PI * 2.0) / float(clip_size);
		int segment_index = int(mod(angle, PI * 2.0) / segment_angle);
		if (angle < (PI * 2.0) * bullet_to_size_ratio) {
			if (int(angle / (PI * 2.0 / float(clip_size)) + margin) == int(angle / segment_angle)) {
				COLOR = is_reloading ? circle_reloading_color : circle_color;
			} else {
				discard;
			}
		} else {
			if (int(angle / (PI * 2.0 / float(clip_size)) + margin) == int(angle / segment_angle)) {
				COLOR = circle_bg_color;
			} else {
				discard;
			}
		}
    } else {
		discard;
	}
}
