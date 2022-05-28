varying vec2 vUv;
varying vec3 vPosition;

void main()
{
    // vec4 mvPosition=modelViewMatrix*vec4(position,1.);
    // gl_PointSize=100.*(1./-mvPosition.z);
    vPosition=position;
    gl_Position=projectionMatrix*modelViewMatrix*vec4(position,1.);
    
    vUv=uv;
}