#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>

in float sphericalVertexDistance;
in float cylindricalVertexDistance;

out vec4 fragColor;

const vec3 LUMINANCE_WEIGHTS = vec3(0.2126, 0.7152, 0.0722);
const float SKY_SATURATION = 1.2;

void main() {
    // saturate sky color
    float luminance = dot(ColorModulator.rgb, LUMINANCE_WEIGHTS);
    vec3 skyColor = clamp(mix(vec3(luminance), ColorModulator.rgb, SKY_SATURATION), 0.0, 1.0);

    fragColor = apply_fog(vec4(skyColor, ColorModulator.a), sphericalVertexDistance, cylindricalVertexDistance, 0.0, FogSkyEnd, FogSkyEnd, FogSkyEnd, FogColor);
}
