import './style.css';
import * as THREE from 'three';
import { OrbitControls } from 'three/examples/jsm/controls/OrbitControls.js';
import * as dat from 'dat.gui';
import vertexShader from './shaders/vertex.glsl';
import fragmentShader from './shaders/fragment.glsl';
import gsap from 'gsap';
// import FontLoader from 'examples/jsm/loader/FontLoader.js';
import { FontLoader } from 'three/examples/jsm/loaders/FontLoader';
import { TextGeometry } from 'three/examples/jsm/geometries/TextGeometry.js';
/**
 * Base
 */
// Debug
const gui = new dat.GUI();
const params = {
    uRotate: 0.0,
    lineWidth: 0.45,
    repeat: 30
};
gui.add(params, 'uRotate', 0.0, Math.PI).step(0.1).onChange((value) => {
    material.uniforms.uRotate.value = value;
});
gui.add(params, 'lineWidth', 0.0, 1.0).step(0.01).onChange((value) => {
    material.uniforms.lineWidth.value = value;
});

gui.add(params, 'repeat').min(1.0).max(100.0).step(1).onChange((value) => {
    material.uniforms.repeat.value = value;
});

// Canvas
const canvas = document.querySelector('canvas.webgl');

// Scene
const scene = new THREE.Scene();

/**
 * Test mesh
 */
// Geometry
const geometry = new THREE.PlaneBufferGeometry(1, 1, 32, 32);

// Material
const material = new THREE.ShaderMaterial({
    uniforms: {
        uTime: { value: 0 },
        uResolution: { value: new THREE.Vector2(window.innerWidth, window.innerHeight) },
        uRotate: { value: 0.0 },
        lineWidth: { value: 0.45 },
        repeat: { value: 30.0 },
    },
    vertexShader: vertexShader,
    fragmentShader: fragmentShader,
    side: THREE.DoubleSide
});

// Mesh
const mesh = new THREE.Mesh(geometry, material);
scene.add(mesh);
// Add boxbuffergeometry
const boxGeometry = new THREE.BoxBufferGeometry(0.5, 0.5, 0.5).translate(0, 0, -0.1);
const boxMesh = new THREE.Mesh(boxGeometry, material);
// scene.add(boxMesh);
boxMesh.position.z = 0.1;

/**
 * Sizes
 */
const sizes = {
    width: window.innerWidth,
    height: window.innerHeight
};
let mouse = new THREE.Vector2(0.0, 0.0);
let mouseTarget = new THREE.Vector2(0.0, 0.0);
document.addEventListener('mousemove', (event) => {
    mouse.x = (event.clientX / sizes.width) * 2 - 1;
    mouse.y = -(event.clientY / sizes.height) * 2 + 1;
});
window.addEventListener('resize', () => {
    // Update sizes
    sizes.width = window.innerWidth;
    sizes.height = window.innerHeight;

    // Update camera
    camera.aspect = sizes.width / sizes.height;
    camera.updateProjectionMatrix();

    // Update renderer
    renderer.setSize(sizes.width, sizes.height);
    renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));
});

/**
 * Camera
 */
// Orthographic camera
const camera = new THREE.OrthographicCamera(-1 / 2, 1 / 2, 1 / 2, -1 / 2, 0.1, 100);

// Base camera
// const camera = new THREE.PerspectiveCamera(75, sizes.width / sizes.height, 0.1, 100)
camera.position.set(0, 0, 2);
scene.add(camera);

// Controls
const controls = new OrbitControls(camera, canvas);
controls.enableDamping = true;

/**
 * Renderer
 */
const renderer = new THREE.WebGLRenderer({
    canvas: canvas,
    antialias: true,
});
renderer.setSize(sizes.width, sizes.height);
renderer.setPixelRatio(Math.min(window.devicePixelRatio, 2));

/**
 * Animate
 */
const clock = new THREE.Clock();

const loader = new FontLoader();
let textMesh;
loader.load('/font.json', function (font) {
    // console.log(font);
    const geometry = new TextGeometry('Hello', {
        font: font,
        size: 0.1,
        height: 0.05,
        curveSegments: 12,
        bevelEnabled: false,
        // bevelThickness: 10,
        // bevelSize: 8,
        // bevelOffset: 0,
        // bevelSegments: 5
    });
    geometry.translate(-0.4, 0, -0.05);
    textMesh = new THREE.Mesh(geometry, material);
    textMesh.position.z = 0.1;
    scene.add(textMesh);
});

const tick = () => {
    // Update controls
    controls.update();

    // Get elapsedtime
    const elapsedTime = clock.getElapsedTime();

    // Update uniforms
    material.uniforms.uTime.value = elapsedTime;
    mouseTarget.x -= 0.1 * (mouseTarget.x - mouse.x);
    mouseTarget.y -= 0.1 * (mouseTarget.y - mouse.y);

    if (textMesh) {

        textMesh.rotation.y = mouseTarget.x;
        textMesh.rotation.x = mouseTarget.y;
    }
    // Render
    renderer.render(scene, camera);

    // Call tick again on the next frame
    window.requestAnimationFrame(tick);
};

tick();