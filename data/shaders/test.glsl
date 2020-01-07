#version 330

in vec3 vertColor;
in vec2 TexCoord;

uniform sampler2D texture;

out vec4 colorOut;
 
void main()
{
    colorOut = texture(texture, TexCoord); //vec4(TexCoord.x, 1.0, TexCoord.y,1.0);
}