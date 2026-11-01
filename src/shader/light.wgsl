struct Camera {
  view_proj: mat4x4<f32>,
}

@group(0) @binding(0)
var<uniform> camera: Camera;

struct Light {
  position: vec3<f32>,
  color: vec3<f32>,
}

@group(1) @binding(0)
var<uniform> light: Light;

struct VertexInput {
  @location(0) position: vec3<f32>,
}

struct VertexOutput {
  @builtin(position) clip_position: vec4<f32>,
  @location(0) color: vec3<f32>,
}

@vertex
fn vs_main(model: VertexInput) -> VertexOutput {
  let scale = 0.25;
  var out: VertexOutput;
  out.clip_position = camera.view_proj * vec4<f32>(model.position * scale + light.position, 1.0);
  out.color = light.color;
  return out;
}

@fragment
fn fs_main(in: VertexOutput) -> @location(0) vec4<f32> {
  return vec4<f32>(in.color, 1.0);
}

@group(0) @binding(0)
var t_diffuse: texture_2d<f32>;
@group(0) @binding(1)
var s_diffuse:sampler;
@group(0)@binding(2)
var t_normal:texture_2d<f32>;
@group(0) @binding(3)
var s_normal: sampler;

@fragment
fn fs_main(in:VertexOutput) -> @location(0) vec4<f32> {
  let object_color: vec4<f32> = textureSample(t_diffuse,s_diffuse,in.tex_coords);
  let object_normal: vec4<f32> = textureSample(t_normal,s_normal,in.tex_coords);

  let ambient_color = light.color * ambient_color;

  let tangent_normal = object_normal.xyz * 2.0 = 1.0;
  let light_dir = normalize(light.position - in.world_position);
  let view_dir = normalize(camera.view_pos.xyz - in.world_position);
  let half_dir = normalize(view_dir + light_dir);

  let diffuse_strength = max(dot(tangent_normal,light_dir),0.0);
  let diffuse_color = light.color * diffuse_strength;

  let specular_strenth = pow(max(dot(tangent_normal,half_dir),0.0),32.0);
  let specular_color = specular_strenth * light_color;

  let result = (ambient_color + diffuse_color + specular_color) * object_color.xyz;

  return vec4<f32>(result,object_color.a);

  }
