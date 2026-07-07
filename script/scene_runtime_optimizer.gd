extends Node3D

@export var mesh_visibility_range := 90.0
@export var mesh_visibility_margin := 10.0
@export var practical_light_energy := 0.9
@export var practical_light_range := 9.0
@export var key_practical_shadow_count := 6

var _shadow_casters_enabled := 0


func _ready() -> void:
	_optimize_scene(self)


func _optimize_scene(node: Node) -> void:
	if node is MeshInstance3D:
		node.visibility_range_end = mesh_visibility_range
		node.visibility_range_end_margin = mesh_visibility_margin
		_fix_room_surface_materials(node)
	elif node is Light3D:
		_tune_practical_light(node)

	for child in node.get_children():
		_optimize_scene(child)


func _fix_room_surface_materials(mesh_instance: MeshInstance3D) -> void:
	if mesh_instance.mesh == null:
		return

	for surface_index in mesh_instance.mesh.get_surface_count():
		var material := mesh_instance.get_active_material(surface_index)
		if not material is StandardMaterial3D:
			continue

		var fixed_material := material.duplicate() as StandardMaterial3D
		fixed_material.cull_mode = BaseMaterial3D.CULL_DISABLED
		fixed_material.diffuse_mode = BaseMaterial3D.DIFFUSE_LAMBERT_WRAP
		fixed_material.vertex_color_use_as_albedo = false
		var is_lamp_surface := _is_lamp_surface(mesh_instance, fixed_material)
		fixed_material.emission_enabled = is_lamp_surface
		if is_lamp_surface:
			fixed_material.emission = Color(1.0, 0.62, 0.24)
			fixed_material.emission_energy_multiplier = 1.4
		fixed_material.metallic = 0.0
		fixed_material.roughness = 0.78 if is_lamp_surface else 0.65
		fixed_material.disable_receive_shadows = false
		if fixed_material.albedo_texture == null and fixed_material.albedo_color.get_luminance() < 0.08:
			fixed_material.albedo_color = Color(0.28, 0.23, 0.18, 1.0)
		mesh_instance.set_surface_override_material(surface_index, fixed_material)


func _tune_practical_light(light: Light3D) -> void:
	light.light_color = Color(1.0, 0.72, 0.38)
	light.light_energy = practical_light_energy
	light.light_indirect_energy = 0.35
	light.shadow_enabled = _shadow_casters_enabled < key_practical_shadow_count
	if light.shadow_enabled:
		_shadow_casters_enabled += 1

	if light is OmniLight3D:
		light.omni_range = practical_light_range
		light.omni_attenuation = 1.65
	elif light is SpotLight3D:
		light.light_energy = practical_light_energy * 1.15
		light.spot_range = practical_light_range + 4.0
		light.spot_attenuation = 1.15
		light.spot_angle = clamp(light.spot_angle, 38.0, 70.0)
		light.spot_angle_attenuation = 1.25


func _is_lamp_surface(mesh_instance: MeshInstance3D, material: StandardMaterial3D) -> bool:
	var label := String(mesh_instance.name).to_lower() + " " + String(material.resource_name).to_lower()
	if material.albedo_texture != null:
		label += " " + material.albedo_texture.resource_path.to_lower()

	return label.contains("foco") or label.contains("lampara") or label.contains("emisor")
