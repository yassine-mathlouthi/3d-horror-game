extends Node3D

@export var mesh_visibility_range := 90.0
@export var mesh_visibility_margin := 10.0


func _ready() -> void:
	_optimize_node(self)


func _optimize_node(node: Node) -> void:
	if node is MeshInstance3D:
		node.visibility_range_end = mesh_visibility_range
		node.visibility_range_end_margin = mesh_visibility_margin
	elif node is Light3D:
		node.shadow_enabled = false
		_limit_light_range(node)

	for child in node.get_children():
		_optimize_node(child)


func _limit_light_range(light: Light3D) -> void:
	if light is OmniLight3D:
		light.omni_range = min(light.omni_range, 12.0)
	elif light is SpotLight3D:
		light.spot_range = min(light.spot_range, 18.0)
