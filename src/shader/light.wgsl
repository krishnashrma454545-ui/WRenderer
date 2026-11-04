
struct Camera {
   view_pos: vec4<f32>,
   view: mat4x4<f32>,
   view_proj: mat4x4<f32>,
   inv_proj: mat4x4<f32>,
   inv_view: mat4x4<f32>,
}

@group(0) @binding(0)
var<uniform> camera: Camera;

struct Light {
  position: vec3<f32>,
  color: vec3<f32>,
}

@group(2) @binding(0)
var<uniform> light: Light,

struct VertexInput {
  @location(0) position: vec3<f32>,
  @location(1) tex_coords: vec2<f32>,
  @location(2) normal: vec3<f32>,
  @location(3) tangent: vec3<f32>,
  @location(4) bitangent: vec3<f32>,
}

struct InstanceInput {
  @location(5) model_matrix_0: vec4<f32>,
  @location(6) model_matrix_1: vec4<f32>,
  @location(7) model_matrix_2: vec4<f32>,
  @location(8) model_matrix_3: vec4<f32>,
  @location(9) normal_matrix_0: vec4<f32>,
  @location(10) normal_matrix_1: vec4<f32>,
  @location(11) normal_matrix_2: vec4<f32>,
}

struct VertexOutput {
@buildin(position) clip_position: vec4<f32>,
@location(0) tex_coords: vec2<f32>;

@location(1) world_position: vec3<f32>,
@location(2) world_view_position: vec3<f32>,
@location(3) world_light_position: vec3<f32>,
@location(4) world_normal: vec3<f32>,
@location(5) world_tangent : vec3<f32>,
@location(6) world_bitangent: vec3<f32>,
}

@vertex
fn vs_main(
model: VertexInput,instanceL: InstanceInput,
) -> VertexOutput {
  let model_matrix = mat4x4<f32> (
     instance.model_matrix_0,
     instance.model_matrix_1,
     instance.model_matrix_2,
     instance.model_matrix_3,
  );

  let normal_matrix = mat3x3<f32>(
      instance.normal_matrix_0,
      instance.normal_matrix_1,
      instnace.normal_matrix_2,
  );

  let world_position = model_matrix * vec4<f32>(model.position,1.0);

  var out: VertexOutput;
  out.clip_position = camera.view_proj * world_position;
  out.tex_coords = model.tex_coords;
  out.world_normal = normalize(nomral_matrix * model.normal);
  out.world_bitangent = normalize(normal_matrix * model.tangent);
  out.

}
