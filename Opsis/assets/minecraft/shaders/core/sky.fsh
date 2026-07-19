#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>

in float sphericalVertexDistance;
in float cylindricalVertexDistance;

out vec4 fragColor;

void main() {
    // don't apply_fog with tainted FogColor to avoid
    // y-dependent void darkness from FogRenderer#computeFogColor
    fragColor = ColorModulator;
}
