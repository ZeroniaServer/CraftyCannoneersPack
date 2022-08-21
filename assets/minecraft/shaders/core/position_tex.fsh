#version 150

uniform sampler2D Sampler0;

uniform vec4 ColorModulator;

in vec2 texCoord0;

out vec4 fragColor;

void main() {
    vec4 color = texture(Sampler0, texCoord0);
    if (color.a == 0.0) {
      discard;
    } else if(color.a == 1.0/255.0) {
      if(color.rgb == vec3(0.0)) {
        discard;
      } else {
        color.a = 1.0;
      }
    }
    fragColor = color * ColorModulator;
}
