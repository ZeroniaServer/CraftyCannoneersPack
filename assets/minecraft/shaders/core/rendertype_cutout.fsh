#version 150

#moj_import <fog.glsl>
#moj_import <emissive_utils.vsh>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float vertexDistance;
in float dimension;
in vec4 vertexColor;
in vec4 lightColor;
in vec4 maxLightColor;
in vec2 texCoord0;
in vec3 faceLightingNormal;
in vec4 normal;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
	float alpha = textureLod(Sampler0, texCoord0, 0.0).a * 255.0;
	color = apply_emissive_for_block(color, lightColor, maxLightColor, faceLightingNormal, vertexDistance, alpha, dimension);
    if (color.a < 0.1) {
        discard;
    }
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
