#version 150

uniform mat4 u_Model;
uniform mat3 u_ModelInvTr;
uniform mat4 u_View;
uniform mat4 u_Proj;
uniform vec3 unif_Camera;
uniform int u_Time;

in vec4 vs_Pos;
in vec4 vs_Nor;

out vec3 fs_Pos;
out vec3 fs_Nor;
out vec4 fs_LightDir;

float magnitude(in vec3 position)
{
    return sqrt(pow(position.x,2)+pow(position.y,2)+pow(position.z,2));
}

void main()
{
    // TODO Homework 4
    fs_Nor = normalize(u_ModelInvTr * vec3(vs_Nor));
    vec4 modelposition = u_Model * vs_Pos;
    vec4 fs_CameraPos=vec4(unif_Camera.x,unif_Camera.y,unif_Camera.z,1);
    fs_LightDir=fs_CameraPos-modelposition;
    fs_Pos = vec3(modelposition);

    //Deformation
    vec3 position=normalize(fs_Pos);
    float radius=2.0;
    vec3 spherePosition=position*radius;
    //transfrom it's value to 0-2
    float time=cos(u_Time*0.005/2*3.1415926+3.1415926/2)+1;
    vec3 newpos=mix(fs_Pos.xyz,spherePosition,time);



    gl_Position = u_Proj * u_View * vec4(newpos.x,newpos.y,newpos.z,1);
}
