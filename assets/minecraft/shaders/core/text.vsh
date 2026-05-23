#version 330

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
#moj_import <minecraft:fog.glsl>
#moj_import <minecraft:sample_lightmap.glsl>
#endif

#moj_import <minecraft:dynamictransforms.glsl>
#moj_import <minecraft:projection.glsl>

in vec3 Position;
in vec4 Color;
in vec2 UV0;
#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
in ivec2 UV2;
#endif

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
uniform sampler2D Sampler2;
out float sphericalVertexDistance;
out float cylindricalVertexDistance;
#endif

out vec4 vertexColor;
out vec2 texCoord0;

void main() {
    gl_Position = ProjMat * ModelViewMat * vec4(Position, 1.0);

#if !defined(IS_GUI) && !defined(IS_SEE_THROUGH)
    sphericalVertexDistance = fog_spherical_distance(Position);
    cylindricalVertexDistance = fog_cylindrical_distance(Position);
    vertexColor = Color * sample_lightmap(Sampler2, UV2);
#else
    vertexColor = Color;
#endif
    texCoord0 = UV0;

// custom text colors
#if defined(IS_GUI)
    // no shadow text
    if (Color == vec4(19/255., 23/255., 9/255., Color.a)) {
        vertexColor = vec4(0); // remove shadow
    }

    else if (Color == vec4(88/255., 92/255., 36/255., Color.a) || Color == vec4(22/255., 23/255., 9/255., Color.a)) {
        vertexColor = vec4(0); // remove text + shadow
    }

    // common chest color
    else if (Color == vec4(169/255., 165/255., 0, Color.a)) {
        vec3 newPos = vec3(Position.x, Position.y - 20.0, Position.z);
        gl_Position = ProjMat * ModelViewMat * vec4(newPos, 1.0);

        // recolor to gray
        vertexColor.r = 84.0/255.0;
        vertexColor.g = 84.0/255.0;
        vertexColor.b = 84.0/255.0;
    }

    // uncommon chest color
    else if (Color == vec4(169/255., 166/255., 0, Color.a)) {
        vec3 newPos = vec3(Position.x, Position.y - 20.0, Position.z);
        gl_Position = ProjMat * ModelViewMat * vec4(newPos, 1.0);

        // recolor to dark aqua
        vertexColor.r = 0;
        vertexColor.g = 145.0/255.0;
        vertexColor.b = 145.0/255.0;
    }

    // rare chest color
    else if (Color == vec4(169/255., 167/255., 0, Color.a)) {
        vec3 newPos = vec3(Position.x, Position.y - 20.0, Position.z);
        gl_Position = ProjMat * ModelViewMat * vec4(newPos, 1.0);

        // recolor to dark aqua
        vertexColor.r = 122.0/255.0;
        vertexColor.g = 0;
        vertexColor.b = 168.0/255.0;
    }

    // cargo barrel color
    else if (Color == vec4(169/255., 168/255., 0, Color.a)) {
        vec3 newPos = vec3(Position.x, Position.y - 6.0, Position.z);
        gl_Position = ProjMat * ModelViewMat * vec4(newPos, 1.0);

        // recolor to custom color
        vertexColor.r = 91.0/255.0;
        vertexColor.g = 70.0/255.0;
        vertexColor.b = 36.0/255.0;
    }
    
    // grave color
    else if (Color == vec4(169/255., 169/255., 0, Color.a)) {
        vec3 newPos = vec3(Position.x, Position.y - 20.0, Position.z);
        gl_Position = ProjMat * ModelViewMat * vec4(newPos, 1.0);

        // recolor to custom color
        vertexColor.r = 2.0/255.0;
        vertexColor.g = 45.0/255.0;
        vertexColor.b = 55.0/255.0;
    }
#endif
}