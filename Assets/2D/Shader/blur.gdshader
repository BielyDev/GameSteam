shader_type canvas_item;

uniform sampler2D TEXTURE_SCREEN : hint_screen_texture;
uniform float blur_force = 1.0f;

void fragment() {
	COLOR = textureLod(TEXTURE_SCREEN, SCREEN_UV, blur_force);
}

