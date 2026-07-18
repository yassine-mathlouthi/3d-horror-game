extends CharacterBody3D

var player = null 
@export var player_path : NodePath 
const RUNNING_SPEED = 2.2 
const  WALKING_SPEED = 1.5
@onready var navigation_agent_3d: NavigationAgent3D = $NavigationAgent3D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	player = get_node(player_path)

# Called every physics frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.y = 0.0

	navigation_agent_3d.set_target_position(player.global_transform.origin)
	var next_pos = navigation_agent_3d.get_next_path_position()
	var direction = next_pos - global_position
	direction.y = 0.0
	direction = direction.normalized()
	velocity.x = direction.x * RUNNING_SPEED
	velocity.z = direction.z * RUNNING_SPEED
	
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
