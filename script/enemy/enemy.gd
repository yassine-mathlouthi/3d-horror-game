extends CharacterBody3D

## The three behaviours available to the enemy.
enum EnemyState {
	PATROL,
	CHASE,
	SEARCH,
}

@export_group("References")
@export var player_path: NodePath

@export_group("Movement")
@export var walking_speed := 1.5
@export var chasing_speed := 2.2
@export var turn_speed := 8.0
@export var arrival_distance := 0.8
@export var model_faces_positive_z := false

@export_group("Patrol")
@export var patrol_wait_time := 1.5

@export_group("Vision")
@export var vision_distance := 18.0
@export_range(1.0, 179.0, 1.0) var vision_angle_degrees := 75.0
@export var eye_height := 1.6
@export var automatic_detection_distance := 1.5
@export var lose_sight_delay := 2.5
@export_flags_3d_physics var vision_collision_mask := 1

@export_group("Search")
@export var search_duration := 10.0
@export var search_point_wait_time := 1.0
@export var search_radius := 8.0

@onready var navigation_agent: NavigationAgent3D = $NavigationAgent3D

var player: Node3D
var current_state := EnemyState.PATROL
var patrol_points: Array[Node3D] = []
var current_destination := Vector3.ZERO
var last_known_player_position := Vector3.ZERO
var time_without_seeing_player := 0.0
var state_timer := 0.0
var wait_timer := 0.0
var last_patrol_point: Node3D
var random := RandomNumberGenerator.new()


func _ready() -> void:
	random.randomize()

	player = get_node_or_null(player_path) as Node3D
	if player == null:
		push_error("Enemy could not find the player. Check player_path in the Inspector.")
		set_physics_process(false)
		return

	_collect_patrol_points()
	if patrol_points.is_empty():
		push_warning("No enemy patrol points were found. Add Marker3D nodes to the enemy_patrol_points group.")

	# Navigation maps synchronize after nodes enter the scene tree.
	# Waiting one physics frame prevents the first path request from happening too early.
	await get_tree().physics_frame
	_change_state(EnemyState.PATROL)


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_update_player_detection(delta)

	match current_state:
		EnemyState.PATROL:
			_update_patrol(delta)
		EnemyState.CHASE:
			_update_chase()
		EnemyState.SEARCH:
			_update_search(delta)

	move_and_slide()


func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		velocity.y = 0.0


func _update_player_detection(delta: float) -> void:
	if _can_see_player():
		last_known_player_position = player.global_position
		time_without_seeing_player = 0.0

		if current_state != EnemyState.CHASE:
			_change_state(EnemyState.CHASE)
		return

	if current_state == EnemyState.CHASE:
		time_without_seeing_player += delta
		if time_without_seeing_player >= lose_sight_delay:
			_change_state(EnemyState.SEARCH)


func _can_see_player() -> bool:
	if player == null:
		return false

	var to_player := player.global_position - global_position
	var distance_to_player := to_player.length()

	if distance_to_player > vision_distance:
		return false

	# Very close players are detected even if they stand slightly behind the enemy.
	if distance_to_player <= automatic_detection_distance:
		return _has_clear_line_to_player()

	var flat_direction := Vector3(to_player.x, 0.0, to_player.z).normalized()
	var enemy_forward := global_basis.z if model_faces_positive_z else -global_basis.z
	enemy_forward.y = 0.0
	enemy_forward = enemy_forward.normalized()

	var minimum_dot := cos(deg_to_rad(vision_angle_degrees * 0.5))
	if enemy_forward.dot(flat_direction) < minimum_dot:
		return false

	return _has_clear_line_to_player()


func _has_clear_line_to_player() -> bool:
	var ray_start := global_position + Vector3.UP * eye_height
	var ray_end := player.global_position + Vector3.UP * eye_height
	var query := PhysicsRayQueryParameters3D.create(
		ray_start,
		ray_end,
		vision_collision_mask
	)
	query.exclude = [self]
	query.collide_with_areas = false

	var hit := get_world_3d().direct_space_state.intersect_ray(query)

	# An empty result means no wall blocked the ray before it reached the player.
	if hit.is_empty():
		return true

	var collider := hit.get("collider") as Node
	return collider == player or (collider != null and player.is_ancestor_of(collider))


func _change_state(new_state: EnemyState) -> void:
	if current_state == new_state and new_state != EnemyState.PATROL:
		return

	current_state = new_state
	wait_timer = 0.0

	match current_state:
		EnemyState.PATROL:
			time_without_seeing_player = 0.0
			_choose_random_patrol_point()

		EnemyState.CHASE:
			time_without_seeing_player = 0.0
			last_known_player_position = player.global_position
			navigation_agent.target_position = last_known_player_position

		EnemyState.SEARCH:
			state_timer = search_duration
			_set_destination(last_known_player_position)

	print("Enemy state changed to: ", EnemyState.keys()[current_state])


func _update_patrol(delta: float) -> void:
	if patrol_points.is_empty():
		_stop_horizontal_movement()
		return

	if _has_reached_destination():
		_stop_horizontal_movement()
		wait_timer += delta

		if wait_timer >= patrol_wait_time:
			wait_timer = 0.0
			_choose_random_patrol_point()
		return

	_move_along_navigation_path(walking_speed, delta)


func _update_chase() -> void:
	# Update the destination every frame while the player is visible or during
	# the short lose_sight_delay memory period.
	current_destination = last_known_player_position
	navigation_agent.target_position = last_known_player_position
	_move_along_navigation_path(chasing_speed, get_physics_process_delta_time())


func _update_search(delta: float) -> void:
	state_timer -= delta

	if state_timer <= 0.0:
		_change_state(EnemyState.PATROL)
		return

	if _has_reached_destination():
		_stop_horizontal_movement()
		wait_timer += delta

		if wait_timer >= search_point_wait_time:
			wait_timer = 0.0
			_choose_nearby_search_point()
		return

	_move_along_navigation_path(walking_speed, delta)


func _move_along_navigation_path(speed: float, delta: float) -> void:
	if navigation_agent.is_navigation_finished():
		_stop_horizontal_movement()
		return

	var next_path_position := navigation_agent.get_next_path_position()
	var direction := next_path_position - global_position
	direction.y = 0.0

	if direction.length_squared() < 0.0001:
		_stop_horizontal_movement()
		return

	direction = direction.normalized()
	velocity.x = direction.x * speed
	velocity.z = direction.z * speed
	_turn_toward_direction(direction, delta)


func _turn_toward_direction(direction: Vector3, delta: float) -> void:
	var target_yaw := (
		atan2(direction.x, direction.z)
		if model_faces_positive_z
		else atan2(-direction.x, -direction.z)
	)
	rotation.y = lerp_angle(rotation.y, target_yaw, turn_speed * delta)

	# Keep the model's existing sideways correction from this project.
	rotation_degrees.z = -11.0


func _stop_horizontal_movement() -> void:
	velocity.x = 0.0
	velocity.z = 0.0


func _set_destination(destination: Vector3) -> void:
	current_destination = destination
	navigation_agent.target_position = destination


func _has_reached_destination() -> bool:
	var flat_offset := current_destination - global_position
	flat_offset.y = 0.0
	return (
		flat_offset.length() <= arrival_distance
		or navigation_agent.is_navigation_finished()
	)


func _collect_patrol_points() -> void:
	patrol_points.clear()

	for node in get_tree().get_nodes_in_group("enemy_patrol_points"):
		if node is Node3D:
			patrol_points.append(node as Node3D)


func _choose_random_patrol_point() -> void:
	if patrol_points.is_empty():
		return

	var candidates := patrol_points.duplicate()
	if last_patrol_point != null and candidates.size() > 1:
		candidates.erase(last_patrol_point)

	var chosen_point: Node3D = candidates[random.randi_range(0, candidates.size() - 1)]
	last_patrol_point = chosen_point
	_set_destination(chosen_point.global_position)


func _choose_nearby_search_point() -> void:
	var nearby_points: Array[Node3D] = []

	for point in patrol_points:
		if point.global_position.distance_to(last_known_player_position) <= search_radius:
			nearby_points.append(point)

	if nearby_points.is_empty():
		# If there are no markers nearby, check the last known position again.
		_set_destination(last_known_player_position)
		return

	var chosen_point: Node3D = nearby_points[random.randi_range(0, nearby_points.size() - 1)]
	_set_destination(chosen_point.global_position)


## Future noise-system hook. Calling this currently does nothing.
func hear_noise(_noise_position: Vector3, _loudness := 1.0) -> void:
	pass


## Future hook for noises caused by a door or interactive object.
func hear_interaction_noise(_noise_position: Vector3) -> void:
	pass
