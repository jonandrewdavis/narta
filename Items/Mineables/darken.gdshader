shader_type canvas_item;

uniform vec4 solid_color : source_color;

uniform bool active = false;

void fragment() {
    vec4 texture_color = texture(TEXTURE, UV);
	if (active == true)
	{
	    COLOR = vec4(mix(texture_color.rgb, solid_color.rgb, solid_color.a), texture_color.a);
	}
}