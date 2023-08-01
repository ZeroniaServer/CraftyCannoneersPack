#version 150

in vec3 Position;
in vec2 UV0;

uniform sampler2D Sampler0;
uniform mat4 ModelViewMat;
uniform mat4 ProjMat;

uniform vec2 ScreenSize;

out vec2 texCoord0;

/*
 * Vertex Color utility function provided by Ts
 * Retrieves the color of a vertex by adjusting the coordinates depending on the vertex id
 * "-offset" for gui elements "+offset" in other places, armor also has vertexid switched, probably more things
*/
vec4 getVertexColor(sampler2D Sampler, int vertexID, vec2 coords) {
	ivec2 texSize = textureSize(Sampler, 0); // get texture size
	vec2 offset = vec2(0.0); // init offset
	float pixelX = (1.0/texSize.x) / 2.0; // includes the width of the texture
	float pixelY = (1.0/texSize.y) / 2.0; // includes the height of the texture
	vertexID = vertexID % 4; // every plane has 4 vertices
	switch(vertexID) {
		case 1: offset = vec2(-pixelX, pixelY); break;
		case 2: offset = vec2(pixelX, pixelY); break;
		case 3: offset = vec2(pixelX, -pixelY); break;
		case 0: offset = vec2(-pixelX, -pixelY); break;
		default: offset = vec2(0.0); break;
	}
	return texture(Sampler, coords - offset); // retrieve vertex's pixel
}

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    texCoord0 = UV0;
	vec4 color = getVertexColor(Sampler0, gl_VertexID, texCoord0); // get the color of the vertex
	if(color.a == 1.0/255.0 && Position.y >= 30) gl_Position = ProjMat * ModelViewMat * vec4(Position + vec3(0.0, -10.0, 0.0), 1.0); // the vertex renders a bossbar, offset it.

    // added by Ts
    vec2 texSize = textureSize(Sampler0,0); // get atlas size
    vec2 coords = round(UV0 * texSize); // get int coords

    if (round(texSize.x / texSize.y) == 2 && texSize.x >= 512){
        float scale = texSize.x / 512;
        if (Position.z == 0.0 // right z level
            && gl_VertexID < 4 // low vertex id
            && ProjMat[2][3] == 0.0 // is gui

            // villager xp bar white fill
            && ((gl_VertexID == 0 && round(coords.x) == 0 && round(coords.y) == 181*scale) || (gl_VertexID == 1 && round(coords.x) == 0 && round(coords.y) == 185*scale) || (gl_VertexID == 2 && round(coords.x) == 101*scale && round(coords.y) == 185*scale) || (gl_VertexID == 3 && round(coords.x) == 101*scale && round(coords.y) == 181*scale))

            // optifine compatibility
            || ((gl_VertexID == 0 && round(coords.x) == 2 && round(coords.y) == 182*scale) || (gl_VertexID == 1 && round(coords.x) == 0 && round(coords.y) == 184*scale) || (gl_VertexID == 2 && round(coords.x) == 99*scale && round(coords.y) == 184*scale) || (gl_VertexID == 3 && round(coords.x) == 99*scale && round(coords.y) == 182*scale))

            // villager xp bar background
            || ((gl_VertexID == 0 && round(coords.x) == 0 && round(coords.y) == 186*scale) || (gl_VertexID == 1 && round(coords.x) == 0 && round(coords.y) == 190*scale) || (gl_VertexID == 2 && round(coords.x) == 101*scale && round(coords.y) == 190*scale) || (gl_VertexID == 3 && round(coords.x) == 101*scale && round(coords.y) == 186*scale))

            // villager xp bar green fill
            || ((gl_VertexID == 0 && round(coords.x) == 0 && round(coords.y) == 191*scale) || (gl_VertexID == 1 && round(coords.x) == 0 && round(coords.y) == 195*scale) || (gl_VertexID == 2 && round(coords.x) == 101*scale && round(coords.y) == 195*scale) || (gl_VertexID == 3 && round(coords.x) == 101*scale && round(coords.y) == 191*scale))
        ) {
            gl_Position = ProjMat * ModelViewMat * vec4(ScreenSize + 100.0, 0.0, 0.0); // move the vertices offscreen
        }
    }
}
