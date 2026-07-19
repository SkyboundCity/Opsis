#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>

in vec3 Position;

out float sphericalVertexDistance;
out float cylindricalVertexDistance;

void main() {
    // remove black disc from SkyRenderer#renderDarkDisc
    if (Position.y < 0) { // bottom sky buffer (y = -16.0)
        gl_Position = vec4(2.0, 2.0, 1.0, 1.0); // move outside clip space
    } else { // top sky buffer (y = 16.0)
        gl_Position = vec4(Position.xz / 256.0, 1.0, 1.0); // cover whole screen
    }

    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
}
