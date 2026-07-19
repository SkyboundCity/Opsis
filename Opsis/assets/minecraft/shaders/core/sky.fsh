#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec3 worldSkyDirection;

out vec4 fragColor;

const vec3 LUMINANCE_WEIGHTS = vec3(0.2126, 0.7152, 0.0722);
const float SKY_SATURATION = 1.4;
const float HAZE_FULL_Y = 0.05;
const float HAZE_CLEAR_Y = 0.2;
const float HAZE_DESATURATION = 0.7;
const float HAZE_BRIGHTNESS = 1.1;
const float HAZE_STRENGTH = 0.4;

void main() {
    // saturate sky color
    float luminance = dot(ColorModulator.rgb, LUMINANCE_WEIGHTS);
    vec3 skyColor = clamp(mix(vec3(luminance), ColorModulator.rgb, SKY_SATURATION), 0.0, 1.0);

    // recreate lower-sky haze
    float worldY = normalize(worldSkyDirection).y;
    float lowerHaze = 1.0 - smoothstep(HAZE_FULL_Y, HAZE_CLEAR_Y, worldY);
    float peakBrightness = max(skyColor.r, max(skyColor.g, skyColor.b));
    vec3 hazeColor = mix(skyColor, vec3(peakBrightness), HAZE_DESATURATION) * HAZE_BRIGHTNESS;

    // don't apply_fog with tainted FogColor to avoid
    // y-dependent void darkness from FogRenderer#computeFogColor
    fragColor = vec4(mix(skyColor, hazeColor, lowerHaze * HAZE_STRENGTH), ColorModulator.a);
}
