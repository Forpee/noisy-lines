uniform float uTime;
uniform vec2 uResolution;
uniform float uRotate;

varying vec2 vUv;

float aastep(float threshold,float value){
    #ifdef GL_OES_standard_derivatives
    float afwidth=length(vec2(dFdx(value),dFdy(value)))*.70710678118654757;
    return smoothstep(threshold-afwidth,threshold+afwidth,value);
    #else
    return step(threshold,value);
    #endif
}

float line(vec2 uv){
    float u=0.;
    u=aastep(.1,uv.x);
    return u;
}

vec2 rotate(vec2 v,float a){
    float s=sin(a);
    float c=cos(a);
    mat2 m=mat2(c,-s,s,c);
    return m*v;
}

void main()
{
    vec2 newUv=gl_FragCoord.xy/uResolution.xy;
    newUv=vec2(fract((newUv.x+newUv.y)*15.),newUv.y);
    
    gl_FragColor=vec4(vec3(line(newUv)),1.);
}