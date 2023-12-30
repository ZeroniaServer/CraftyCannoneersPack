#version 150

// Checking for the exact alpha value breaks things, so I use this function to cut down on space while also making it work better.

bool check_alpha(float textureAlpha, float targetAlpha) {
	
	float targetLess = targetAlpha - 0.01;
	float targetMore = targetAlpha + 0.01;
	return (textureAlpha > targetLess && textureAlpha < targetMore);
	
}

// Gets the dimension that an object is in, -1 for The Nether, 0 for The Overworld, 1 for The End.

float get_dimension(vec4 minLightColor) {

	if (minLightColor.r == minLightColor.g && minLightColor.g == minLightColor.b) return 0.0; // Shadows are grayscale in The Overworld
	else if (minLightColor.r > minLightColor.g) return -1.0; // Shadows are more red in The Nether
	else return 1.0; // Shadows are slightly green in The End
	
}

// Gets the face lighting of a block. Credits to Venaxsys for the original function.

vec4 get_face_lighting(vec3 normal, float dimension) { 
	
	vec4 faceLighting = vec4(1.0, 1.0, 1.0, 1.0);
	vec3 absNormal = abs(normal);
	float top = 229.0 / 255.0;
	float bottom = 127.0 / 255.0;
	float east = 153.0 / 255.0;
	float north = 204.0 / 255.0;
	
	// Top (only required in the Nether)
	if (normal.y > normal.z && normal.y > normal.x && check_alpha(dimension, -1.0)) faceLighting = vec4(top, top, top, 1.0); // It's not really checking the alpha but I'm too stubborn to change the function name
	
	// Bottom
	if (normal.y < normal.z && normal.y < normal.x && !check_alpha(dimension, -1.0)) faceLighting = vec4(bottom, bottom, bottom, 1.0);
	else if (normal.y < normal.z && normal.y < normal.x && check_alpha(dimension, -1.0)) faceLighting = vec4(top, top, top, 1.0);

	// East-West
	if (absNormal.x > absNormal.z && absNormal.x > absNormal.y) faceLighting = vec4(east, east, east, 1.0);

	// North-South
	if (absNormal.z > absNormal.x && absNormal.z > absNormal.y) faceLighting = vec4(north, north, north, 1.0);

	return faceLighting;
}


// Checks the alpha and removes face lighting if required.

vec4 face_lighting_check(vec3 normal, float inputAlpha, float dimension) {

	if (check_alpha(inputAlpha, 250.0)) return get_face_lighting(normal, dimension); // Checks for alpha 250, and runs it through the remove_face_lighting() function if it is. Used in the example pack for lime concrete.
	else return vec4(1.0, 1.0, 1.0, 1.0); // If the block doesn't need to have its face lighting removed, returns 1.0 so nothing gets divided.
	
}

// for item
vec4 apply_emissive_perspective_for_item(vec4 inputColor, vec4 lightColor, int isGUI, float zPos, float FogStart, float FogEnd, float inputAlpha) {
	vec4 remappingColor = inputColor * lightColor;

	if(check_alpha(inputAlpha, 255.0)) {        // GUI O | FirstPerson O | ThirdPerson O | Emssive X
		// Default
	} else if(check_alpha(inputAlpha, 254.0)) { // GUI O | FirstPerson O | ThirdPerson O | Emssive O
		if(isGUI == 1 && zPos > 100.0) {
			remappingColor.a = 1.0;
		} else {
			remappingColor = inputColor;
			remappingColor.a = 1.0;
		}
	} else if(check_alpha(inputAlpha, 253.0)) { // GUI O | FirstPerson O | ThirdPerson X | Emssive X
		if(isGUI == 1 && zPos > 100.0) {
			remappingColor.a = 1.0;
		} else {
			if(FogStart > FogEnd) {
				if(isGUI == 0) {
					remappingColor.a = 1.0;
				} else {
					remappingColor.a = 0.0;
				}
			} else {
				remappingColor.a = 0.0;
			}
		}
	} else if(check_alpha(inputAlpha, 252.0)) { // GUI O | FirstPerson O | ThirdPerson X | Emssive O
		if(isGUI == 1 && zPos > 100.0) {
			remappingColor.a = 1.0;
		} else {
			if(FogStart > FogEnd) {
				if(isGUI == 0) {
					remappingColor = inputColor;
					remappingColor.a = 1.0;
				} else {
					remappingColor.a = 0.0;
				}
			} else {
				remappingColor.a = 0.0;
			}
		}
	} else if(check_alpha(inputAlpha, 251.0)) { // GUI O | FirstPerson X | ThirdPerson O | Emssive X
		if(isGUI == 1 && zPos > 100.0) {
			remappingColor.a = 1.0;
		} else {
			if(FogStart > FogEnd) {
				if(isGUI == 0) {
					remappingColor.a = 0.0;
				} else {
					remappingColor.a = 1.0;
				}
			} else {
				remappingColor.a = 1.0;
			}
		}
	} else if(check_alpha(inputAlpha, 250.0)) { // GUI O | FirstPerson X | ThirdPerson O | Emssive O
		if(isGUI == 1 && zPos > 100.0) {
			remappingColor.a = 1.0;
		} else {
			if(FogStart > FogEnd) {
				if(isGUI == 0) {
					remappingColor.a = 0.0;
				} else {
					remappingColor.a = 1.0;
					remappingColor = inputColor;
				}
			} else {
				remappingColor = inputColor;
				remappingColor.a = 1.0;
			}
		}
	} else if(check_alpha(inputAlpha, 249.0)) { // GUI X | FirstPerson O | ThirdPerson O | Emssive X
		if(isGUI == 1 && zPos > 100.0) {
			remappingColor.a = 0.0;
		} else {
			remappingColor.a = 1.0;
		}
	} else if(check_alpha(inputAlpha, 248.0)) {	// GUI X | FirstPerson O | ThirdPerson O | Emssive O
		if(isGUI == 1 && zPos > 100.0) {
			remappingColor.a = 0.0;
		} else {
			remappingColor = inputColor;
			remappingColor.a = 1.0;
		}
	} else if(check_alpha(inputAlpha, 247.0)) {	// GUI X | FirstPerson O | ThirdPerson X | Emssive X
		if(isGUI == 1 && zPos > 100.0) {
			remappingColor.a = 0.0;
		} else {
			if(FogStart > FogEnd) {
				if(isGUI == 0) {
					remappingColor.a = 1.0;
				} else {
					remappingColor.a = 0.0;
				}
			} else {
				remappingColor.a = 0.0;
			}
		}
	} else if(check_alpha(inputAlpha, 246.0)) {	// GUI X | FirstPerson O | ThirdPerson X | Emssive O
		if(isGUI == 1 && zPos > 100.0) {
			remappingColor.a = 0.0;
		} else {
			if(FogStart > FogEnd) {
				if(isGUI == 0) {
					remappingColor = inputColor;
					remappingColor.a = 1.0;
				} else {
					remappingColor.a = 0.0;
				}
			} else {
				remappingColor.a = 0.0;
			}
		}
	} else if(check_alpha(inputAlpha, 245.0)) {	// GUI X | FirstPerson X | ThirdPerson O | Emssive X
		if(isGUI == 1 && zPos > 100.0) {
			remappingColor.a = 0.0;
		} else {
			if(FogStart > FogEnd) {
				if(isGUI == 0) {
					remappingColor.a = 0.0;
				} else {
					remappingColor.a = 1.0;
				}
			} else {
				remappingColor.a = 1.0;
			}
		}
	} else if(check_alpha(inputAlpha, 244.0)) {	// GUI X | FirstPerson X | ThirdPerson O | Emssive O
		if(isGUI == 1 && zPos > 100.0) {
			remappingColor.a = 0.0;
		} else {
			if(FogStart > FogEnd) {
				if(isGUI == 0) {
					remappingColor.a = 0.0;
				} else {
					remappingColor.a = 1.0;
					remappingColor = inputColor;
				}
			} else {
				remappingColor = inputColor;
				remappingColor.a = 1.0;
			}
		}
	} else if(check_alpha(inputAlpha, 243.0)) { // GUI O | FirstPerson X | ThirdPerson X | Emssive - (only GUI don't need Emssive setting)
		if(isGUI == 1 && zPos > 100.0) {
			remappingColor.a = 1.0;
		} else {
			remappingColor.a = 0.0;
		}
	} else if (check_alpha(inputAlpha, 26.0)) { // special color for dura bars in custom GUIs
        if (isGUI == 1 && zPos > 100.0) {
            remappingColor.a = 0.1;
        } else {
            remappingColor.a = 0.0;
        }
    }
	return remappingColor;
}

// for third person glowing
vec4 apply_emissive_perspective_glowing(vec4 inputColor, float inputAlpha) {
	vec4 remappingColor = inputColor;
	if(check_alpha(inputAlpha, 243.0) || check_alpha(inputAlpha, 246.0) || check_alpha(inputAlpha, 247.0) || check_alpha(inputAlpha, 252.0) || check_alpha(inputAlpha, 253.0)) {
		remappingColor.a = 0.0;
    }
	return remappingColor;
}

// for block
vec4 apply_emissive_for_block(vec4 inputColor, vec4 lightColor, vec3 normal, float inputAlpha, float dimension) {
	vec4 remappingColor = inputColor * lightColor / face_lighting_check(normal, inputAlpha, dimension);
	if(check_alpha(inputAlpha, 242.0)) {
		remappingColor = inputColor / face_lighting_check(normal, inputAlpha, dimension);
		remappingColor.a = 1.0;
	}
	return remappingColor;
}

// for particle, entitiy, entity block and item(player head, banner, ...)
vec4 apply_global_emissive(vec4 inputColor, vec4 lightColor, float inputAlpha) {
	vec4 remappingColor = inputColor * lightColor;
	if(check_alpha(inputAlpha, 242.0)) {
		remappingColor = inputColor;
		remappingColor.a = 1.0;
	}
	return remappingColor;
}