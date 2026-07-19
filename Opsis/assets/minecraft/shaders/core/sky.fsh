#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec3 worldSkyDirection;

out vec4 fragColor;

const float HAZE_FULL_Y = -0.1;
const float HAZE_CLEAR_Y = 0.2;
const float HAZE_DESATURATION = 0.68;
const float HAZE_BRIGHTNESS = 1.16;
const float HAZE_STRENGTH = 0.4;

void main() {
    // recreate lower-sky haze
    float worldY = normalize(worldSkyDirection).y;
    float lowerHaze = 1.0 - smoothstep(HAZE_FULL_Y, HAZE_CLEAR_Y, worldY);
    float peakBrightness = max(ColorModulator.r, max(ColorModulator.g, ColorModulator.b));
    vec3 hazeColor = mix(ColorModulator.rgb, vec3(peakBrightness), HAZE_DESATURATION) * HAZE_BRIGHTNESS;

    // don't apply_fog with tainted FogColor to avoid
    // y-dependent void darkness from FogRenderer#computeFogColor
    fragColor = vec4(mix(ColorModulator.rgb, hazeColor, lowerHaze * HAZE_STRENGTH), ColorModulator.a);
}
