// extern OCTAVES 6
// extern LACUNARITY 2.0
// extern GAIN 0.5
// extern AMPLITUDE 0.5
// extern FREQUENCY 0.0
// extern SCALE 3.0

extern vec2 resolution;
extern float time;

extern float OCTAVES;
extern float LACUNARITY;
extern float GAIN;
extern float AMPLITUDE;
extern float FREQUENCY;
extern float SCALE;

vec2 random2(vec2 p) { return fract(sin(vec2(dot(p, vec2(127.1, 311.7)), dot(p, vec2(269.5, 183.3)))) * 43758.5453); }

float random(vec2 st) { return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453123); }

float CellularNoise(vec2 coord)
{
    coord *= SCALE;

    vec2 intComp = floor(coord);
    vec2 fractComp = fract(coord);

    float minDist = 10000.0;

    for (int y = -1; y <= 1; y++)
    {
        for (int x = -1; x <= 1; x++)
        {
            vec2 adjTile = vec2(x, y);
            vec2 randPoint = random2(intComp + adjTile);
            randPoint.x += 0.4 * sin(time * random(randPoint));
            float dist = length(adjTile + randPoint - fractComp);
            minDist = min(minDist, dist);
        }
    }

    return minDist;
}

float FractualNoise(vec2 coord)
{
    float value = 0.0;
    float amplitude = AMPLITUDE;
    float frequency = FREQUENCY;

    for (int i = 0; i < OCTAVES; i++)
    {
        value += amplitude * CellularNoise(coord);
        coord *= LACUNARITY;
        amplitude *= GAIN;
    }

    return value;
}

vec4 effect(vec4 color, Image texture, vec2 texCoords, vec2 screenCoords)
{
    vec2 coord = screenCoords.xy / resolution.xy;
    coord.x *= resolution.x / resolution.y;

    float noiseValue = FractualNoise(coord * 3.0);
    vec3 finalColor = vec3(noiseValue);

    return vec4(finalColor, 1.0) * color;
}
