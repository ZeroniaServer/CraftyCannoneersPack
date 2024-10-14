#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:utils.vsh>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;
uniform float FogStart;
uniform float FogEnd;
uniform vec4 FogColor;

in float zPos;
in float vertexDistance;
in vec4 vertexColor;
in vec4 lightMapColor;
in vec4 overlayColor;
in vec2 texCoord0;

flat in int isGUI;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0);
#ifdef ALPHA_CUTOUT
    if (color.a < ALPHA_CUTOUT) {
        discard;
    }
#endif
    color *= vertexColor * ColorModulator;
#ifndef NO_OVERLAY
    color.rgb = mix(overlayColor.rgb, color.rgb, overlayColor.a);
#endif
#ifndef EMISSIVE
    float alpha = textureLod(Sampler0, texCoord0, 0.0).a * 255.0;
    #ifdef ENTITY_CUTOUT
        color = apply_emissive_perspective_for_item(color, lightMapColor, isGUI, zPos, FogStart, FogEnd, alpha);
    #else
        color = apply_global_emissive(color, lightMapColor, alpha);
    #endif
#endif
    fragColor = linear_fog(color, vertexDistance, FogStart, FogEnd, FogColor);
}