// Originally sourced from https://www.shadertoy.com/view/ldfSWs
// Thank you Iñigo :)

vec2 plane(vec3 p, vec4 n) {
  n = normalize(n);
  return vec2(dot(p,n.xyz) + n.w, -1.0);
}

vec3 calcRayIntersection(vec3 rayOrigin, vec3 rayDir, float maxd, float precis) {
  float latest = precis * 2.0;
  float rdist  = +0.0;
  float dist   = +0.0;
  float type   = -1.0;
  vec3  res    = vec3(-1.0, 0.0, -1.0);

  for (int i = 0; i < steps; i++) {
    if (latest < precis || dist > maxd) break;

    vec3 p = rayOrigin + rayDir * dist;
    vec2 result1 = map(p);
    vec2 result2 = plane(p, vec4(0, 1, 0, 0));

    latest = result1.x < result2.x ? result1.x : result2.x;
    type   = result1.x < result2.x ? result1.y : result2.y;
    dist  += latest;
  }

  if (dist < maxd) {
    rdist = map(rayOrigin + rayDir * dist).x;
    res = vec3(dist, type, rdist);
  }

  return res;
}

vec3 calcRayIntersection(vec3 rayOrigin, vec3 rayDir) {
  return calcRayIntersection(rayOrigin, rayDir, 20.0, 0.001);
}

#pragma glslify: export(calcRayIntersection)
