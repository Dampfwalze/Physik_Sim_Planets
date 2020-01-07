#version 330
 
uniform mat4 transform;
 
in vec4 position;
in vec3 color;
in vec2 texCoord;
 
out vec3 vertColor;
out vec2 TexCoord;
 
void main(){
 
  TexCoord = texCoord;
  vertColor = color;
  gl_Position = transform * position;
}