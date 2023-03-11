#version 150

in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;


void main()
{
    // TODO Homework 5
    vec4 textureColor=texture2D(u_RenderedTexture,fs_UV);
    //Gray formula
    float gray=textureColor.r*0.21+textureColor.g*0.72+textureColor.b*0.07;

    color = vec3(gray,gray,gray);
}
