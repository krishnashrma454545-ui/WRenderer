const PI: f32 = 3.1415926535897932384626433832795;

struct Face {
  forward: vec3<f32>,
  up: vec3<f32>,
  right: vec3<f32>,
}

@group(0) @binding(0)
var src: texture_2d<f32>;

@group(0) @binding(1)
var dst: texture_storage_2d_array<rgba16float, write>;

@compute @workgroup_size(16, 16, 1)
fn compute_equirect_to_cubemap(
  @builtin(global_invocation_id) gid: vec3<u32>,
) {
  let dst_dimensions = textureDimensions(dst);
  if gid.x >= dst_dimensions.x || gid.y >= dst_dimensions.y || gid.z >= 6u {
    return;
  }

  var FACES: array<Face, 6> = array<Face, 6>(
    Face(vec3<f32>(1.0, 0.0, 0.0), vec3<f32>(0.0, 1.0, 0.0), vec3<f32>(0.0, 0.0, 1.0)),
    Face(vec3<f32>(-1.0, 0.0, 0.0), vec3<f32>(0.0, 1.0, 0.0), vec3<f32>(0.0, 0.0, -1.0)),
    Face(vec3<f32>(0.0, -1.0, 0.0), vec3<f32>(0.0, 0.0, 1.0), vec3<f32>(1.0, 0.0, 0.0)),
    Face(vec3<f32>(0.0, 1.0, 0.0), vec3<f32>(0.0, 0.0, -1.0), vec3<f32>(1.0, 0.0, 0.0)),
    Face(vec3<f32>(0.0, 0.0, 1.0), vec3<f32>(0.0, 1.0, 0.0), vec3<f32>(-1.0, 0.0, 0.0)),
    Face(vec3<f32>(0.0, 0.0, -1.0), vec3<f32>(0.0, 1.0, 0.0), vec3<f32>(1.0, 0.0, 0.0)),
  );

  let dst_size = vec2<f32>(dst_dimensions.xy);
  let cube_uv = vec2<f32>(gid.xy) / dst_size * 2.0 - 1.0;

  let face = FACES[gid.z];
  let spherical = normalize(face.forward + face.right * cube_uv.x + face.up * cube_uv.y);

  let inv_atan = vec2<f32>(0.1591, 0.3183);
  let eq_uv = vec2<f32>(atan2(spherical.z, spherical.x), asin(spherical.y)) * inv_atan + 0.5;
  let eq_pixel = vec2<i32>(eq_uv * vec2<f32>(textureDimensions(src)));

  let sample = textureLoad(src, eq_pixel, 0);
  textureStore(dst, gid.xy, gid.z, sample);
}
