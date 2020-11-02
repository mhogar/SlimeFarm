shader_type canvas_item;

uniform vec4 body_color = vec4(0.415, 0.745, 0.188, 1.0);
uniform vec4 highlight_color = vec4(0.553, 0.89, 0.31, 1.0);

uniform vec3 body_mask = vec3(0.518, 0.494, 0.53);
uniform vec3 highlight_mask = vec3(0.501, 0.678, 0.718);

uniform float threshold = 0.15;

void fragment() {
	vec4 tex_color = texture(TEXTURE, UV);
	
	//check if the tex color is less than the threshold
	if(abs(length(tex_color.rgb - body_mask)) < threshold)
	{
	    //update the mask to the new color
	    tex_color.rgb = body_color.rgb;
	}
	else if (abs(length(tex_color.rgb - highlight_mask)) < threshold) {
		//update the mask to the new color
	    tex_color.rgb = highlight_color.rgb;
	}
	
	COLOR = tex_color;
}
