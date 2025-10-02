#version 330

#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:dynamictransforms.glsl>

uniform sampler2D Sampler0;

in float sphericalVertexDistance;
in float cylindricalVertexDistance;
in vec4 vertexColor;
in vec2 texCoord0;

out vec4 fragColor;

bool in_range(float source, float target) {
	float targetLess = target - 0.3;
	float targetMore = target + 0.3;
	return (source > targetLess && source < targetMore);
}

void main() {
    vec4 color = texture(Sampler0, texCoord0).rrrr * vertexColor * ColorModulator;

    float r = color.r * 255.0;
    float g = color.g * 255.0;
    float b = color.b * 255.0;
    if (in_range(r, 144.0) && in_range(g, 144.0) && in_range(b, 22.0)) {
        color = vec4(1, 1, 1, 22./255.);
    }
    else if (in_range(r, 144.0) && in_range(g, 144.0) && in_range(b, 15.0)) {
        color = vec4(1, 1, 1, 15./255.);
    }
    else if (color.a < 0.1) {
        discard;
    }
    fragColor = apply_fog(color, sphericalVertexDistance, cylindricalVertexDistance, FogEnvironmentalStart, FogEnvironmentalEnd, FogRenderDistanceStart, FogRenderDistanceEnd, FogColor);
}