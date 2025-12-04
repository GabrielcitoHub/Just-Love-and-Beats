vec4 effect(vec4 color, Image texture, vec2 texCoord, vec2 screenCoord)
{
    vec4 tex = Texel(texture, texCoord);

    // final alpha = texture alpha * setColor alpha
    float a = tex.a * color.a;

    return vec4(1.0, 1.0, 1.0, a);
}
