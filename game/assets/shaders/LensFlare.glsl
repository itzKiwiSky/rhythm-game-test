extern vec2 resolution;  // Resolução da tela
extern vec2 light_pos;   // Posição da luz (em pixels)
extern float radius;     // Raio de influência da luz
extern float intensity;  // Intensidade base da luz

vec3 lensflare(vec2 uv, vec2 pos) {
    vec2 delta = uv - pos;
    float dist = length(delta);

    float f0 = 1.0 / (dist * 16.0 + 1.0);

    f0 = f0 + f0 * (0.8 - dist * 0.1);

    return vec3(f0);
}

vec4 effect(vec4 vcolor, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec2 uv = (screen_coords / resolution) - 0.5;

    vec2 normalized_light_pos = (light_pos / resolution) - 0.5;

    float dist_to_light = length(screen_coords - light_pos);
    float light_intensity = intensity * max(0.0, 1.0 - (dist_to_light / radius));

    vec3 color = vec3(1.4, 1.2, 1.0) * lensflare(uv, normalized_light_pos);
    color *= light_intensity;

    return vec4(color, 1.0);
}
