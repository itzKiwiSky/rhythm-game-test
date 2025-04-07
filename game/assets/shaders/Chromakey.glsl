vec4 effect(vec4 color, Image texture, vec2 texture_coords, vec2 screen_coords)
{
    vec4 pixel = Texel(texture, texture_coords) * color;
    if (pixel.g > 0.99 && pixel.r < 0.1 && pixel.b < 0.1)
    {
        return vec4(0.0, 0.0, 0.0, 0.0);
    }
    return pixel;
}