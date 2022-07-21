#version 150

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

uniform vec2 ScreenSize;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

    vertexDistance = length((ModelViewMat * vec4(Position, 1.0)).xyz);
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;

	  // delete sidebar numbers
  	if(	Position.z == 0.0 && // check if the depth is correct (0 for gui texts)
  			gl_Position.x >= 0.82 && gl_Position.y >= -0.65 && // check if the position matches the sidebar
  			vertexColor.g  == 84.0/255.0 && vertexColor.b == 84.0/255.0 && vertexColor.r == 252.0/255.0 // check if the color is the sidebar red color
  		) {
          gl_Position = ProjMat * ModelViewMat * vec4(ScreenSize + 100.0, 0.0, 0.0); // move the vertices offscreen, idk if this is a good solution for that but vec4(0.0) doesnt do the trick for everyone
      }

    // move fake sidebar numbers (aqua)
    if(	Position.z == 0.0 && // check if the depth is correct (0 for gui texts)
  			gl_Position.x >= 0.82 && gl_Position.y >= -0.65 && // check if the position matches the sidebar
  			vertexColor.g == 252.0/255.0 && vertexColor.b == 252.0/255.0 && vertexColor.r == 84.0/255.0 // check if the color is the aqua color
  		) {

        // offset position
        vec3 newPos = vec3(Position.x + 14.0, Position.y, Position.z);
        gl_Position = ProjMat * ModelViewMat * vec4(newPos, 1.0);

        // recolor to red
        vertexColor.g = 84.0/255.0;
        vertexColor.b = 84.0/255.0;
        vertexColor.r = 252.0/255.0;
      }

    // move fake sidebar numbers (gold)
    if(	Position.z == 0.0 && // check if the depth is correct (0 for gui texts)
  			gl_Position.x >= 0.82 && gl_Position.y >= -0.65 && // check if the position matches the sidebar
  			vertexColor.g == 168.0/255.0 && vertexColor.b == 0.0/255.0 && vertexColor.r == 252.0/255.0 // check if the color is the gold color
  		) {

        // offset position
        vec3 newPos = vec3(Position.x + 20.0, Position.y, Position.z);
        gl_Position = ProjMat * ModelViewMat * vec4(newPos, 1.0);

        // recolor to red
        vertexColor.g = 84.0/255.0;
        vertexColor.b = 84.0/255.0;
        vertexColor.r = 252.0/255.0;
      }
}