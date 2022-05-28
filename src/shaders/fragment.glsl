uniform float uTime;
uniform vec2 uResolution;

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

void main()
{
    vec2 newUv=gl_FragCoord.xy/uResolution.xy;
    gl_FragColor=vec4(vUv,1.,1.);
}