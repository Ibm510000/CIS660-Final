#version 150

uniform ivec2 u_Dimensions;
uniform int u_Time;

in vec2 fs_UV;

out vec3 color;

uniform sampler2D u_RenderedTexture;

//HelpLog
//https://www.shadertoy.com/view/Xd23Dh

//Water tuberlence

float random(float x) {

    return fract(sin(x) * 10000.);

}

float noise_water(vec2 p) {

    return random(p.x + p.y * 10000.);

}

vec2 sw(vec2 p) { return vec2(floor(p.x), floor(p.y)); }
vec2 se(vec2 p) { return vec2(ceil(p.x), floor(p.y)); }
vec2 nw(vec2 p) { return vec2(floor(p.x), ceil(p.y)); }
vec2 ne(vec2 p) { return vec2(ceil(p.x), ceil(p.y)); }

float smoothNoise(vec2 p) {

    vec2 interp = smoothstep(0., 1., fract(p));
    float s = mix(noise_water(sw(p)), noise_water(se(p)), interp.x);
    float n = mix(noise_water(nw(p)), noise_water(ne(p)), interp.x);
    return mix(s, n, interp.y);

}

float fractalNoise(vec2 p) {

    float x = 0.;
    x += smoothNoise(p      );
    x += smoothNoise(p * 2. ) / 2.;
    x += smoothNoise(p * 4. ) / 4.;
    x += smoothNoise(p * 8. ) / 8.;
    x += smoothNoise(p * 16.) / 16.;
    x /= 1. + 1./2. + 1./4. + 1./8. + 1./16.;
    return x;

}

float movingNoise(vec2 p) {

    float x = fractalNoise(p + 0.005*u_Time);
    float y = fractalNoise(p - 0.005*u_Time);
    return fractalNoise(p + vec2(x, y));

}

// call this for water noise function
float nestedNoise(vec2 p) {

    float x = movingNoise(p);
    float y = movingNoise(p + 100.);
    return movingNoise(p + vec2(x, y));

}

//Base wrap

float colormap_red(float x) {
    if (x < 0.0) {
        return 54.0 / 255.0;
    } else if (x < 20049.0 / 82979.0) {
        return (829.79 * x + 54.51) / 255.0;
    } else {
        return 1.0;
    }
}

float colormap_green(float x) {
    if (x < 20049.0 / 82979.0) {
        return 0.0;
    } else if (x < 327013.0 / 810990.0) {
        return (8546482679670.0 / 10875673217.0 * x - 2064961390770.0 / 10875673217.0) / 255.0;
    } else if (x <= 1.0) {
        return (103806720.0 / 483977.0 * x + 19607415.0 / 483977.0) / 255.0;
    } else {
        return 1.0;
    }
}

float colormap_blue(float x) {
    if (x < 0.0) {
        return 54.0 / 255.0;
    } else if (x < 7249.0 / 82979.0) {
        return (829.79 * x + 54.51) / 255.0;
    } else if (x < 20049.0 / 82979.0) {
        return 127.0 / 255.0;
    } else if (x < 327013.0 / 810990.0) {
        return (792.02249341361393720147485376583 * x - 64.364790735602331034989206222672) / 255.0;
    } else {
        return 1.0;
    }
}

vec4 colormap(float x) {
    return vec4(colormap_red(x), colormap_green(x), colormap_blue(x), 1.0);
}

float rand(vec2 n) {
    return fract(sin(dot(n, vec2(12.9898, 4.1414))) * 43758.5453);
}

float noise(vec2 p){
    vec2 ip = floor(p);
    vec2 u = fract(p);
    u = u*u*(3.0-2.0*u);

    float res = mix(
        mix(rand(ip),rand(ip+vec2(1.0,0.0)),u.x),
        mix(rand(ip+vec2(0.0,1.0)),rand(ip+vec2(1.0,1.0)),u.x),u.y);
    return res*res;
}

const mat2 mtx = mat2( 0.80,  0.60, -0.60,  0.80 );

float fbm( vec2 p )
{
    float f = 0.0;

    f += 0.500000*noise( p + 0.005*u_Time  ); p = mtx*p*2.02;
    f += 0.031250*noise( p ); p = mtx*p*2.01;
    f += 0.250000*noise( p ); p = mtx*p*2.03;
    f += 0.125000*noise( p ); p = mtx*p*2.01;
    f += 0.062500*noise( p ); p = mtx*p*2.04;
    f += 0.015625*noise( p + sin(0.005*u_Time) );

    return f/0.96875;
}

float pattern( in vec2 p )
{
        return fbm( p + fbm( p + fbm( p ) ) );
}

//Main Function

void main()
{

        vec2 uv = fs_UV;
        float n = nestedNoise(uv);
        float shade = pattern(uv);
        //Base wrap Color
        vec4 fragColor_01 = vec4(colormap(shade).rgb, shade);
        //Water tuberlence Color
        vec4 fragColor_02 = vec4(mix(vec3(.4, .6, 1.), vec3(.1, .2, 1.), n), 1.);
        vec2 p = 0.5 - 0.5*cos(0.05*u_Time*vec2(1.0,0.5));
        //Use noise to sample the render texture so that the picture will be affected
        vec2 noiseUV=vec2(n,n);
        vec4 diffuseColor=texture2D(u_RenderedTexture,vec2(fs_UV+0.1*noiseUV)-vec2(0.05,0.05));
        color = fragColor_01.rgb+diffuseColor.rgb*fragColor_02.rgb;

}
