uniform float uTime;
uniform vec2 uResolution;
uniform float uRotate;
uniform float lineWidth;
varying vec2 vUv;

float aastep(float threshold,float value){
    #ifdef GL_OES_standard_derivatives
    float afwidth=length(vec2(dFdx(value),dFdy(value)))*.70710678118654757;
    return smoothstep(threshold-afwidth,threshold+afwidth,value);
    #else
    return step(threshold,value);
    #endif
}

//	Classic Perlin 2D Noise
//	by Stefan Gustavson
//
vec2 fade(vec2 t){return t*t*t*(t*(t*6.-15.)+10.);}
vec4 permute(vec4 x){return mod(((x*34.)+1.)*x,289.);}
float cnoise(vec2 P){
    vec4 Pi=floor(P.xyxy)+vec4(0.,0.,1.,1.);
    vec4 Pf=fract(P.xyxy)-vec4(0.,0.,1.,1.);
    Pi=mod(Pi,289.);// To avoid truncation effects in permutation
    vec4 ix=Pi.xzxz;
    vec4 iy=Pi.yyww;
    vec4 fx=Pf.xzxz;
    vec4 fy=Pf.yyww;
    vec4 i=permute(permute(ix)+iy);
    vec4 gx=2.*fract(i*.0243902439)-1.;// 1/41 = 0.024...
    vec4 gy=abs(gx)-.5;
    vec4 tx=floor(gx+.5);
    gx=gx-tx;
    vec2 g00=vec2(gx.x,gy.x);
    vec2 g10=vec2(gx.y,gy.y);
    vec2 g01=vec2(gx.z,gy.z);
    vec2 g11=vec2(gx.w,gy.w);
    vec4 norm=1.79284291400159-.85373472095314*
    vec4(dot(g00,g00),dot(g01,g01),dot(g10,g10),dot(g11,g11));
    g00*=norm.x;
    g01*=norm.y;
    g10*=norm.z;
    g11*=norm.w;
    float n00=dot(g00,vec2(fx.x,fy.x));
    float n10=dot(g10,vec2(fx.y,fy.y));
    float n01=dot(g01,vec2(fx.z,fy.z));
    float n11=dot(g11,vec2(fx.w,fy.w));
    vec2 fade_xy=fade(Pf.xy);
    vec2 n_x=mix(vec2(n00,n01),vec2(n10,n11),fade_xy.x);
    float n_xy=mix(n_x.x,n_x.y,fade_xy.y);
    return 2.3*n_xy;
}

float line(vec2 uv,float width){
    float u=0.;
    u=aastep(width,uv.x)-aastep(1.-width,uv.x);
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
    newUv=rotate(newUv,uRotate);
    float noise=cnoise(newUv);
    newUv+=vec2(noise);
    newUv=vec2(fract((newUv.x)*15.),newUv.y);
    
    gl_FragColor=vec4(vec3(line(newUv,lineWidth)),1.);
}