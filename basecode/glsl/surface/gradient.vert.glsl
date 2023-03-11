#version 150

uniform mat4 u_Model;
uniform mat3 u_ModelInvTr;
uniform mat4 u_View;
uniform mat4 u_Proj;
uniform vec3 unif_Camera;

in vec4 vs_Pos;
in vec4 vs_Nor;

out vec3 fs_Nor;
out vec3 fs_LightVec;
void main()
{
    // TODO Homework 4
    vec4 modelposition = u_Model * vs_Pos; 

    fs_Nor = normalize(u_ModelInvTr * vec3(vs_Nor));
    vec4 fs_CameraPos=vec4(unif_Camera.x,unif_Camera.y,unif_Camera.z,1);
    vec4 LightVec = fs_CameraPos - modelposition;
    fs_LightVec=LightVec.rgb;

    gl_Position = u_Proj * u_View * modelposition;
}


