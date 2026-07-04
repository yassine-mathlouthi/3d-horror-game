extends Node3D

@export var mesh_visibility_range := 90.0
@export var mesh_visibility_margin := 10.0


func _ready() -> void:
	_optimize_scene(self)


func _optimize_scene(node: Node) -> void:
	if node is MeshInstance3D:
		node.visibility_range_end = mesh_visibility_range
		node.visibility_range_end_margin = mesh_visibility_margin
		_fix_room_surface_materials(node)

	for child in node.get_children():
		_optimize_scene(child)


func _fix_room_surface_materials(mesh_instance: MeshInstance3D) -> void:
	if mesh_instance.mesh == null:
		return

	for surface_index in mesh_instance.mesh.get_surface_count():
		var material := mesh_instance.get_active_material(surface_index)
		if not material is StandardMaterial3D:
			continue

		var material_name := material.resource_name.to_lower()
		if not _is_room_surface_material(material_name):
			continue

		var fixed_material := material.duplicate() as StandardMaterial3D
		fixed_material.cull_mode = BaseMaterial3D.CULL_DISABLED
		fixed_material.diffuse_mode = BaseMaterial3D.DIFFUSE_LAMBERT_WRAP
		fixed_material.vertex_color_use_as_albedo = false
		fixed_material.emission_enabled = false
		fixed_material.metallic = 0.0
		fixed_material.roughness = 0.65
		fixed_material.disable_receive_shadows = false
		mesh_instance.set_surface_override_material(surface_index, fixed_material)


func _is_room_surface_material(material_name: String) -> bool:
	return (
		material_name.contains("pared")
		or material_name.contains("piso")
		or material_name.contains("muro")
		or material_name.contains("techo")
		or material_name.contains("ladrillos")
		or material_name.contains("casa")
		or material_name.contains("cuar")
		or material_name.contains("ban")
		or material_name.contains("plastico")
	)
