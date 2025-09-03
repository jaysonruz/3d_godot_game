shader_type spatial;

uniform vec4 color1 : source_color = vec4(0.2, 0.2, 0.2, 1.0); // dark color
uniform vec4 color2 : source_color = vec4(0.9, 0.9, 0.9, 1.0); // light color
uniform float scale = 4.0; // how many squares per unit

void fragment() {
    // Scale UVs so more/fewer checkers fit
    vec2 uv = UV * scale;

    // Decide if we're on dark or light square
    float checker = mod(floor(uv.x) + floor(uv.y), 2.0);

    // Pick between the two colors
    vec4 col = mix(color1, color2, checker);

    ALBEDO = col.rgb;
}
