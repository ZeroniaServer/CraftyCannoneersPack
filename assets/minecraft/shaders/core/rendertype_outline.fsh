#version 150

#moj_import <utils.vsh>

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;

in vec4 vertexColor;
in vec2 texCoord0;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0);
    float alpha = textureLod(Sampler0, texCoord0, 0.0).a * 255.0;
    color = apply_emissive_perspective_glowing(color, alpha);
    if (color.a < 0.1) {
        discard;
    }
    fragColor = vec4(ColorModulator.rgb * vertexColor.rgb, ColorModulator.a);
}
