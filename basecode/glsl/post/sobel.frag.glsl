#version 150

in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;
uniform int u_Time;
uniform ivec2 u_Dimensions;

uniform float Horizontal[9]={3,0,-3,10,0,-10,3,0,-3};
uniform float Vertical[9]={3,10,3,0,0,0,-3,-10,-3};


void main()
{
    // TODO Homework 5

    //Get screen pixel position
    float x_pos=gl_FragCoord.x;
    float y_pos=gl_FragCoord.y;
    //Horizontal&&Vertical Color (sobel)
    vec4 horizontalColor;
    vec4 verticalColor;

    vec4 sumColor;

    //Sobel Calculation
    for(int i=-1;i<=1;i++)
    {
        for(int j=-1;j<=1;j++)
        {
            vec2 coords=vec2(x_pos+j,y_pos+i)/u_Dimensions;
            horizontalColor+=texture2D(u_RenderedTexture,coords)*Horizontal[(i+1)*3+j+1];

            verticalColor+=texture2D(u_RenderedTexture,coords)*Vertical[(i+1)*3+j+1];
        }
    }


    horizontalColor=horizontalColor*horizontalColor;
    verticalColor=verticalColor*verticalColor;

    color=sqrt(horizontalColor.rgb+verticalColor.rgb);
}
