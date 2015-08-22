# glsl-ruler

[![stable](http://badges.github.io/stability-badges/dist/stable.svg)](http://github.com/badges/stability-badges)

Helper module for debugging raytraced SDFs inspired by
[Johann Korndorfer's](https://twitter.com/cupe_cupe)
["How to Create Content with Signed Distance Functions"](https://www.youtube.com/watch?v=s8nFqwOho-s)
talk at [NVScene 2015](http://nv.scene.org/2015/).

Thanks to [Ryan Alexander](https://twitter.com/notlion) for
his [example implementation on Shadertoy](https://www.shadertoy.com/view/XlB3DV) :sparkles:

[![](http://i.imgur.com/ECqABqF.gif)](http://stack.gl/glsl-ruler/)

**[view demo](http://stack.gl/glsl-ruler/)**

## Usage

[![NPM](https://nodei.co/npm/glsl-ruler.png)](https://nodei.co/npm/glsl-ruler/)

### `trace = require(glsl-ruler/trace, <map>, <steps>)`

Currently, `glsl-ruler` needs to handle raytracing on your behalf – it does so using an API very similar to [glsl-raytrace](http://github.com/stackgl/glsl-raytrace). For further details, check out that project's documentation.

#### `vec3 trace(vec3 ro, vec3 rd)`

The key difference here between `glsl-ruler/trace` and `glsl-raytrace` is that instead of returning a `vec2`, `trace` will return a `vec3` with the elements corresponding to:

1. The signed distance value retrieved from a raytrace of your `map` function merged with the ruler plane.
2. A second attribute for assigning an ID to surfaces. This will be `-1.0` if the ray hit the plane.
3. The signed distance value retrieved from a raytrace of only
your `map` function. You can then use this to color the plane.

### `color = require(glsl-color)`

#### `vec3 color(float distance)`

Returns an RGB color for the plane based on the `distance` value of your signed distance field.

## Example

By combining the above two modules together, you can quickly tweak existing glslify-driven raytracers to debug and explore 3D SDFs:

``` glsl
vec2 doModel(vec3 p);

#pragma glslify: camera = require('glsl-turntable-camera')
#pragma glslify: trace = require('glsl-ruler/trace', map = doModel, steps = 90)
#pragma glslify: color = require('glsl-ruler/color')

// creates a unit sphere at the origin
vec2 doModel(vec3 p) {
  return vec2(length(p) - 1.0, 1.0);
}

void main() {
  vec3 color = vec3(0);
  vec3 rayOrigin, rayDirection;

  camera(iGlobalTime * 0.175, 2.5, 3.0, iResolution, rayOrigin, rayDirection);

  // This works just the same as glsl-raytrace would,
  // however returning a vec3 instead of a vec2.
  vec3 t = raytrace(rayOrigin, rayDirection);
  if (t.x > -0.5) {
    vec3 pos = rayOrigin + t.x * rayDirection;
    vec3 nor = getNormal(pos);

    color = nor * 0.5 + 0.5;

    // if t.y is below 0.5, then you need to draw
    // the ruler plane instead. Simply feed it t.z,
    // the SDF from your map function, to get a color
    // in return.
    color = t.y < -0.5 ? gradient(t.z) : color;
  }

  gl_FragColor = vec4(color, 1.0);
}
```

For a full example, see [demo.js](demo.js).

## Contributing

See [stackgl/contributing](https://github.com/stackgl/contributing) for details.

## License

MIT. See [LICENSE.md](http://github.com/stackgl/glsl-ruler/blob/master/LICENSE.md) for details.
