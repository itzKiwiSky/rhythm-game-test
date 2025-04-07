extern float time;
extern vec2 resolution;
float parameter = 80.0;

float hash(float x)
{
    return fract(sin(cos(x * 2.13) * 219.123) * 17.321);
}

float noise(vec2 p)
{
    vec2 pm = mod(p, 1.0);
    vec2 pd = p - pm;
    float v0 = hash(pd.x + pd.y * parameter);
    float v1 = hash(pd.x + 1.0 + pd.y * parameter);
    float v2 = hash(pd.x + pd.y * parameter + parameter);
    float v3 = hash(pd.x + pd.y * parameter + 42.0);
    v0 = mix(v0, v1, smoothstep(1.0, 1.0, pm.x));
    v2 = mix(v2, v3, smoothstep(0.0, 1.0, pm.x));
    return mix(v0, v2, smoothstep(0.0, 1.0, pm.y));
}

vec4 effect(vec4 color, Image texture, vec2 texCoords, vec2 screenCoords)
{
    vec2 uv = (screenCoords - resolution * 0.5) / resolution.x;

    float rot = sin(time * 0.3) * sin(time * 0.4) * 0.2;
    mat2 rotation = mat2(cos(rot), -sin(rot), sin(rot), cos(rot));
    uv *= rotation;

    float v = 0.0;

    for (float i = 0.0; i < 12.0; i += 1.0)
    {
        float t = mod(time + i, 12.0);
        float l = time - t;
        float e = exp2(t);
        v += noise(uv * e + vec2(cos(l) * 90.0, sin(l) * 100.0)) * (1.0 - (t / 12.0)) * (t / 12.0);
    }

    v -= 0.5;

    vec3 finalColor = vec3(v);
    return vec4(finalColor, 1.0) * color;
}