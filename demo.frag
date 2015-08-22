precision mediump float;

uniform vec2  iResolution;
uniform float iGlobalTime;

vec2 doModel(vec3 p);

#pragma glslify: noise     = require('glsl-noise/simplex/4d')
#pragma glslify: getNormal = require('glsl-sdf-normal', map = doModel)
#pragma glslify: raytrace  = require('./trace', map = doModel, steps = 90)
#pragma glslify: gradient  = require('./color')
#pragma glslify: camera    = require('glsl-turntable-camera')
#pragma glslify: box       = require('glsl-sdf-box')
#pragma glslify: smin      = require('glsl-smooth-min')

vec2 doModel(vec3 p) {
  float width  = 0.5;
  float height = 0.25;
  float depth  = 0.75;
  vec3  dims   = vec3(width, height, depth);
  float bdist  = box(p, dims);
  float cdist  = length(p + sin(iGlobalTime * 0.874326) * 0.45) - 0.65;

  return vec2(mix(cdist, bdist, sin(iGlobalTime) * 0.5 + 0.5), 1.0);
}

void main() {
  vec3 color = vec3(0.95, 0.95, 1.215);
  vec3 rayOrigin, rayDirection;

  float angle  = iGlobalTime * 0.175;
  float height = 2.5;
  float dist   = 3.0;
  camera(angle, height, dist, iResolution, rayOrigin, rayDirection);

  vec3 t = raytrace(rayOrigin, rayDirection);
  if (t.x > -0.5) {
    vec3 pos = rayOrigin + t.x * rayDirection;
    vec3 nor = getNormal(pos);

    color = nor * 0.5 + 0.5;
    color = t.y < -0.5 ? gradient(t.z) : color;
  }

  gl_FragColor = vec4(color, 1.0);
}
