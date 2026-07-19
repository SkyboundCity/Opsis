#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec3 worldSkyDirection;

out vec4 fragColor;

void main() {
    // recreate lower-sky haze
    float worldY = normalize(worldSkyDirection).y;
    float lowerHaze = 1.0 - smoothstep(-0.1, 0.2, worldY);
    float peakBrightness = max(ColorModulator.r, max(ColorModulator.g, ColorModulator.b));
    vec3 hazeColor = mix(ColorModulator.rgb, vec3(peakBrightness), 0.68) * 1.16;

    // don't apply_fog with tainted FogColor to avoid
    // y-dependent void darkness from FogRenderer#computeFogColor
    fragColor = vec4(mix(ColorModulator.rgb, hazeColor, lowerHaze * 0.4), ColorModulator.a);
}
