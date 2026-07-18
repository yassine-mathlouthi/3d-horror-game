extends CharacterBody3D

var player = null 
@export var player_path : NodePath 
const RUNNING_SPEED = 2.2 
const  WALKING_SPEED = 1.5
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node(player_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	velocity = Vector3.ZERO
	navigation_agent_3d.set_target_position(player.global_transform.origin)
	var next_pos = navigation_agent_3d.get_next_path_position()
	velocity = (next_pos - global_transform.origin).normalized() * RUNNING_SPEED
	
	look_at(
		Vector3(
			player.global_position.x,
			global_position.y,
			player.global_position.z
		),
		Vector3.UP
	)
	rotation_degrees.z = -10.5
	
	move_and_slide()
