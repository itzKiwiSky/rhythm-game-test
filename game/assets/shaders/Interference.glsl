extern float time;
extern float intensity;
extern float speed;

vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec2 uv = texture_coords;
    float linePattern = sin(screen_coords.y * 0.05 + time * speed) * 0.5 + 0.5;
    float distortion = linePattern * intensity * sin(time * speed * 3.0 + screen_coords.y * 0.1);
    uv.x += distortion * 0.1;
    return Texel(texture, uv) * color;
}
