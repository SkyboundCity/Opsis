#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>

in vec3 Position;

out float sphericalVertexDistance;
out float cylindricalVertexDistance;
out vec3 worldSkyDirection;

const float SKY_DISC_CLIP_SCALE = 256.0;

void main() {
    // remove black disc from SkyRenderer#renderDarkDisc
    if (Position.y < 0) { // bottom sky buffer (y = -16.0)
        gl_Position = vec4(2.0, 2.0, 1.0, 1.0); // move outside clip space
    } else { // top sky buffer (y = 16.0)
        gl_Position = vec4(Position.xz / SKY_DISC_CLIP_SCALE, 1.0, 1.0); // cover whole screen
    }

    // reconstruct a world-space view direction independent of camera position
    // used to recreate lower-sky haze
    vec2 skyNdc = Position.xz / SKY_DISC_CLIP_SCALE;
    vec3 viewDirection = vec3(
        skyNdc.x / ProjMat[0][0],
        skyNdc.y / ProjMat[1][1],
        -1.0
    );
    worldSkyDirection = transpose(mat3(ModelViewMat)) * viewDirection;

    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
}
