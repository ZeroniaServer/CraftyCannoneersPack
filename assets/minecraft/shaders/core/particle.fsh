#version 150

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:utils.vsh>
#moj_import <minecraft:dynamictransforms.glsl>

uniform sampler2D Sampler0;

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec2 texCoord0;
in vec4 vertexColor;
in vec4 lightColor;
in vec4 maxLightColor;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0) * vertexColor * ColorModulator;
	float alpha = textureLod(Sampler0, texCoord0, 0.0).a * 255.0;
    
    // discards minecraft lighting with desired opacity
    bool emissive = check_alpha(alpha, 250.0);
    color = apply_global_emissive(color, emissive ? maxLightColor : lightColor, emissive ? 255.0 : alpha);

    if (color.a < 0.1) {
        discard;
    }
    fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}