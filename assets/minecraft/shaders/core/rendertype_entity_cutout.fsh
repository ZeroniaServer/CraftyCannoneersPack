#version 150

#moj_import <fog.glsl>
#moj_import <utils.vsh>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float zPos;
in float vertexDistance;
in vec4 vertexColor;
in vec4 lightColor;
in vec4 maxLightColor;
in vec4 overlayColor;
in vec2 texCoord0;
in vec4 normal;

flat in int isGUI;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0) * ColorModulator;
	float alpha = textureLod(Sampler0, texCoord0, 0.0).a * 255.0;
    // discards minecraft lighting with desired opacity
    if (!check_alpha(alpha, 250.0)) {
        color *= vertexColor;
    }
    color.rgb = mix(overlayColor.rgb, color.rgb, overlayColor.a);
    color = apply_emissive_perspective_for_item(color, lightColor, isGUI, zPos, FogStart, FogEnd, alpha);
    if (color.a < 0.1) {
        discard;
    }
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}
