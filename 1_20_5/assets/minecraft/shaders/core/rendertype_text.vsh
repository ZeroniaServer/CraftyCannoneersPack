#version 150

#moj_import <fog.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
in ivec2 UV2;

uniform sampler2D Sampler0;
uniform sampler2D Sampler2;

uniform mat4 ModelViewMat;
uniform mat4 ProjMat;
uniform int FogShape;

out float vertexDistance;
out vec4 vertexColor;
out vec2 texCoord0;

void main() {
    // vanilla behavior
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);
    vertexDistance = fog_distance(Position, FogShape);
    vertexColor = Color * texelFetch(Sampler2, UV2 / 16, 0);
    texCoord0 = UV0;

    // no shadow text: 
    if (Color == vec4(78/255., 92/255., 36/255., Color.a)) {
        vertexColor = texelFetch(Sampler2, UV2 / 16, 0); // remove color from no shadow marker
    } else if (Color == vec4(19/255., 23/255., 9/255., Color.a)) {
        vertexColor = vec4(0); // remove shadow
    }

    else if (Color == vec4(88/255., 92/255., 36/255., Color.a) || Color == vec4(22/255., 23/255., 9/255., Color.a)) {
        vertexColor = vec4(0); // remove text + shadow
    }

    // common chest color
    else if (Color == vec4(169/255., 165/255., 0, Color.a)) {
        vec3 newPos = vec3(Position.x, Position.y - 20.0, Position.z + 200.0);
        gl_Position = ProjMat * ModelViewMat * vec4(newPos, 1.0);

        // recolor to gray
        vertexColor.r = 84.0/255.0;
        vertexColor.g = 84.0/255.0;
        vertexColor.b = 84.0/255.0;
    }

    // uncommon chest color
    else if (Color == vec4(169/255., 166/255., 0, Color.a)) {
        vec3 newPos = vec3(Position.x, Position.y - 20.0, Position.z + 200.0);
        gl_Position = ProjMat * ModelViewMat * vec4(newPos, 1.0);

        // recolor to dark aqua
        vertexColor.r = 0;
        vertexColor.g = 145.0/255.0;
        vertexColor.b = 145.0/255.0;
    }

    // rare chest color
    else if (Color == vec4(169/255., 167/255., 0, Color.a)) {
        vec3 newPos = vec3(Position.x, Position.y - 20.0, Position.z + 200.0);
        gl_Position = ProjMat * ModelViewMat * vec4(newPos, 1.0);

        // recolor to dark aqua
        vertexColor.r = 122.0/255.0;
        vertexColor.g = 0;
        vertexColor.b = 168.0/255.0;
    }

    // cargo barrel color
    else if (Color == vec4(169/255., 168/255., 0, Color.a)) {
        vec3 newPos = vec3(Position.x, Position.y - 6.0, Position.z + 200.0);
        gl_Position = ProjMat * ModelViewMat * vec4(newPos, 1.0);

        // recolor to custom color
        vertexColor.r = 91.0/255.0;
        vertexColor.g = 70.0/255.0;
        vertexColor.b = 36.0/255.0;
    }
    
    // grave color
    else if (Color == vec4(169/255., 169/255., 0, Color.a)) {
        vec3 newPos = vec3(Position.x, Position.y - 20.0, Position.z + 200.0);
        gl_Position = ProjMat * ModelViewMat * vec4(newPos, 1.0);

        // recolor to custom color
        vertexColor.r = 2.0/255.0;
        vertexColor.g = 45.0/255.0;
        vertexColor.b = 55.0/255.0;
    }

    // displace custom gui texture to hide in nametag view
    else if (Color == vec4(123/255., 123/255., 0, Color.a)) {
        vertexColor = texelFetch(Sampler2, UV2 / 16, 0);
        vec3 newPos = vec3(Position.x, Position.y, Position.z + 200.0);
        gl_Position = ProjMat * ModelViewMat * vec4(newPos, 1.0);
    }
}
