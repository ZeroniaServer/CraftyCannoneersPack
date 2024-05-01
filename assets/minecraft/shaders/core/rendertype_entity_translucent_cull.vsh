#version 150

#moj_import <light.glsl>
#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in vec2 UV1;
in ivec2 UV2;
in vec3 Normal;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

uniform vec3 Light0_Direction;
uniform vec3 Light1_Direction;
uniform int FogShape;

out float zPos;
out float vertexDistance;
out vec4 vertexColor;
out vec4 lightColor;
out vec4 maxLightColor;
out vec2 texCoord0;
out vec2 texCoord1;
out vec2 texCoord2;
out vec4 normal;

flat out int isGUI;

//gui item model detection from Onnowhere
bool isgui(mat4 ProjMat) {
    return ProjMat[2][3] == 0.0;
}

void main() {
    isGUI = int(isgui(ProjMat));
    zPos = Position.z;
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    
    vertexDistance = fog_distance(Position, FogShape);
    vertexColor = minecraft_mix_light(Light0_Direction, Light1_Direction, Normal, Color);
    lightColor = vertexDistance <= 800 ? minecraft_sample_lightmap(Sampler2, UV2) : texelFetch(Sampler2, UV2 / 16, 0);
	//lightColor = minecraft_sample_lightmap(Sampler2, UV2);
	maxLightColor = minecraft_sample_lightmap(Sampler2, ivec2(240.0, 240.0));
    texCoord0 = UV0;
    texCoord1 = UV1;
    texCoord2 = UV2;
    normal = ProjMat * ModelViewMat * vec4(Normal, 0.0);
}
