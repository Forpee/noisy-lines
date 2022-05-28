uniform float uTime;

varying vec2 vUv;

float aastep(float threshold,float value){
    #ifdef GL_OES_standard_derivatives
    float afwidth=length(vec2(dFdx(value),dFdy(value)))*.70710678118654757;
    return smoothstep(threshold-afwidth,threshold+afwidth,value);
    #else
    return step(threshold,value);
    #endif
}

void main()
{
    gl_FragColor=vec4(vUv,1.,1.);
}