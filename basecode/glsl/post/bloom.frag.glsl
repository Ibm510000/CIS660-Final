#version 150

in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;
uniform int u_Time;
uniform ivec2 u_Dimensions;
uniform const float GaussianKernal[121]={
            0.006849,0.007239,0.007559,0.007795,0.007941,0.00799,0.007941,0.007795,0.007559,0.007239,0.006849,
            0.007239,0.007653,0.00799,0.00824,0.008394,0.008446,0.008394,0.00824,0.00799,0.007653,0.007239,
            0.007559,0.00799,0.008342,0.008604,0.008764,0.008819,0.008764,0.008604,0.008342,0.00799,0.007559,
            0.007795,0.00824 ,0.008604,0.008873,0.009039,0.009095,0.009039,0.008873,0.008604,0.00824 ,0.007795,
            0.007941,0.008394 ,0.008764,0.009039,0.009208,0.009265,0.009208,0.009039,0.008764,0.008394,0.007941,
            0.00799 ,0.008446 ,0.008819,0.009095,0.009265,0.009322,0.009265,0.009095,0.008819,0.008446,0.00799,
            0.007941,0.008394 ,0.008764,0.009039,0.009208,0.009265,0.009208,0.009039,0.008764,0.008394,0.007941,
            0.007795,0.00824  ,0.008604,0.008873,0.009039,0.009095,0.009039,0.008873,0.008604,0.00824 ,0.007795,
            0.007559,0.00799  ,0.008342,0.008604,0.008764,0.008819,0.008764,0.008604,0.008342,0.00799 ,0.007559,
            0.007239,0.007653 ,0.00799 ,0.00824 ,0.008394,0.008446,0.008394,0.00824 ,0.00799 ,0.007653,0.007239,
            0.006849,0.007239 ,0.007559,0.007795,0.007941,0.00799 ,0.007941,0.007795,0.007559,0.007239,0.006849};


void main()
{
    // TODO Homework 5

    float x_Step=1.0/u_Dimensions.x;
    float y_Step=1.0/u_Dimensions.y;
    vec4 pixelColor;
    float sumLightluminance;

    //First got light intensity of the pixel
    pixelColor=texture(u_RenderedTexture,fs_UV);
    sumLightluminance=pixelColor.r*0.30+pixelColor.g*0.59+pixelColor.b*0.11;

    float threshold=0.1;
    //luminance bigger than threshold
    vec4 sumColor;
    //do gaussian blur
    if(sumLightluminance>threshold)
    {
        for(int i=-5;i<6;i++)
        {
            for(int j=-5;j<6;j++)
            {
                sumColor+=texture(u_RenderedTexture,vec2(fs_UV.x+i*x_Step,fs_UV.y+j*y_Step))*GaussianKernal[11*(i+5)+j+5];
            }
        }
        pixelColor+=sumColor;
    }


    pixelColor.r=clamp(pixelColor.r,0,255);
    pixelColor.g=clamp(pixelColor.g,0,255);
    pixelColor.b=clamp(pixelColor.b,0,255);
    color=pixelColor.rgb;

}
