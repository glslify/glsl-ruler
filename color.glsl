vec3 getColor(float t) {
  float t1 = pow(fract(t), 5.0);
  float t2 = pow(fract(t * 10.0), 2.0);
  float t3 = clamp(t1 * 0.25 + t2 * 0.15, 0.0, 1.0);
  vec3 c = mix(mix(vec3(0.1,0.2,1.0), vec3(1.0,0.2,0.1), t*0.5), vec3(1.0), smoothstep(0.2,0.5,t*0.12));
  return vec3(c) - vec3(t3);
}

#pragma glslify: export(getColor)
