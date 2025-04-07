extern Image img;
extern Image PixelGrid;

vec4 effect(vec4 color, Image tex, vec2 texCoord, vec2 screenCoord)
{
    vec2 newCoord = texCoord * 0.25;

    float x = floor(newCoord.x * 1024.0);
    float y = floor(newCoord.y * 768.0);

    newCoord.x = (x / 1024.0) + (1.0 / 2048.0);
    newCoord.y = (y / 768.0) + (1.0 / 1536.0);

    vec4 newColor = Texel(img, newCoord);

    vec4 grid = Texel(PixelGrid, texCoord);

    newColor.rgb -= grid.rgb;

    return newColor * color;
}
