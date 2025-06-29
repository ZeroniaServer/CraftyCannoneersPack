#version 150

// Copied from light.glsl
vec4 minecraft_sample_lightmap(sampler2D lightMap, ivec2 uv) {
    return texture(lightMap, clamp(uv / 256.0, vec2(0.5 / 16.0), vec2(15.5 / 16.0)));
}

// Checking for the exact alpha value breaks things, so I use this function to cut down on space while also making it work better.
bool check_alpha(float textureAlpha, float targetAlpha) {
	float targetLess = targetAlpha - 0.01;
	float targetMore = targetAlpha + 0.01;
	return (textureAlpha > targetLess && textureAlpha < targetMore);
}

// for particle, entity, entity block and item(player head, banner, ...)
vec4 apply_global_emissive(vec4 inputColor, vec4 lightColor, float inputAlpha) {
    vec4 remappingColor = inputColor * lightColor;
    if(check_alpha(inputAlpha, 254.0) || check_alpha(inputAlpha, 252.0) || check_alpha(inputAlpha, 250.0) || check_alpha(inputAlpha, 248.0) || check_alpha(inputAlpha, 246.0) || check_alpha(inputAlpha, 244.0) || check_alpha(inputAlpha, 242.0)) { // always emissive
        remappingColor = inputColor;
        remappingColor.a = 1.0;
    }
    return remappingColor;
}