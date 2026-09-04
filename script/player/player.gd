extends CharacterBody3D

const JUMP_VELOCITY := 4.5
const RUN_SPEED := 3.2
const WALKING_SPEED := 1.8
const MIN_LOOK_ANGLE := deg_to_rad(-60.0)
const MAX_LOOK_ANGLE := deg_to_rad(70.0)
const FIRST_PERSON_HIDDEN_LAYER := 2
const INTERACTION_DISTANCE := 3.0
@onready var flashlight_fill: OmniLight3D = $camera_mount/Camera3D/FlashlightFill
@onready var flashlight: SpotLight3D = $camera_mount/Camera3D/Flashlight


@onready var jumpscare_animation_player: AnimationPlayer = $JumpscareAnimationPlayer
@onready var jumpscare_audio: AudioStreamPlayer = $JumpscareAudio
@onready var game_over_menu: Control = $CanvasLayer/GameOverMenu
@onready var restart_button: Button = $CanvasLayer/GameOverMenu/CenterContainer/MenuPanel/MenuContent/RestartButton

var controls_enabled := true
var jumpscare_active := false



@export var sensitivity := 0.12
@export var FLASH_BY_DEFAULT : bool = false
@onready var camera_mount: Node3D = $camera_mount
@onready var camera: Camera3D = $camera_mount/Camera3D
@onready var key_text: Label = $CanvasLayer/BoxContainer/KeyText
@onready var fps_label: Label = $CanvasLayer/FpsLabel
@onready var animation_player: AnimationPlayer = $visuals/mixamo_base/AnimationPlayer
@onready var visuals: Node3D = $visuals

var base_camera_position: Vector3
var bob_time := 0.0
var is_running := false
var look_pitch := 0.0


func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	base_camera_position = camera_mount.position
	camera.near = 0.05
	camera.cull_mask &= ~FIRST_PERSON_HIDDEN_LAYER
	_set_flashlight_visible(FLASH_BY_DEFAULT)
	_hide_from_first_person_camera(visuals)
	key_text.hide()
	game_over_menu.hide()
	restart_button.pressed.connect(_on_restart_button_pressed)



func _input(event: InputEvent) -> void:
	if not controls_enabled:
		return
	if event is InputEventMouseMotion:
		var look_delta: Vector2 = event.relative * sensitivity
		rotate_y(deg_to_rad(-look_delta.x))
		visuals.rotate_y(deg_to_rad(look_delta.x))
		look_pitch = clamp(look_pitch + deg_to_rad(-look_delta.y), MIN_LOOK_ANGLE, MAX_LOOK_ANGLE)
		camera_mount.rotation.x = look_pitch

func _physics_process(delta: float) -> void:
	fps_label.text = "FPS: %d" % Engine.get_frames_per_second()
	_handle_interaction()

	is_running = Input.is_action_pressed("run")
	var speed := RUN_SPEED if is_running else WALKING_SPEED
	
	if not controls_enabled:
		velocity = Vector3.ZERO
		return
	_handle_interaction()
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		
	# flash light logique 
	if Input.is_action_just_pressed("flash"):
		FLASH_BY_DEFAULT = !FLASH_BY_DEFAULT
		_set_flashlight_visible(FLASH_BY_DEFAULT)
		
	var input_dir := Input.get_vector("right", "left", "forward", "back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		_play_movement_animation()
		visuals.look_at(direction + position)
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		_play_animation("idle")
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	_update_camera_bob(delta, direction)
	move_and_slide()

func start_jumpscare(enemy: Node3D) -> void:
	if jumpscare_active:
		return

	jumpscare_active = true
	controls_enabled = false
	velocity = Vector3.ZERO
	key_text.hide()

	# Remove camera bob before aiming at the enemy.
	camera_mount.position = base_camera_position
	camera_mount.rotation = Vector3.ZERO
	look_pitch = 0.0
	camera.rotation = Vector3.ZERO

	# Turn the player's horizontal forward direction toward the enemy.
	var look_target := enemy.global_position
	look_target.y = global_position.y
	if global_position.distance_squared_to(look_target) > 0.0001:
		look_at(look_target, Vector3.UP)

	# Stop the first-person body from keeping an unrelated visual direction.
	visuals.rotation.y = 0.0

	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

	if jumpscare_audio.stream != null:
		jumpscare_audio.play()

	jumpscare_animation_player.play(&"jumpscare_camera")
	await jumpscare_animation_player.animation_finished

	game_over_menu.show()
	restart_button.grab_focus()


func _handle_interaction() -> void:
	var query := PhysicsRayQueryParameters3D.create(
		camera.global_position,
		camera.global_position + (-camera.global_basis.z * INTERACTION_DISTANCE)
	)
	query.exclude = [self]
	query.collide_with_areas = true

	var hit := get_world_3d().direct_space_state.intersect_ray(query)
	if hit.is_empty():
		key_text.hide()
		return

	var collider: Object = hit["collider"]
	if collider == null:
		key_text.hide()
		return

	if collider.has_method("interact"):
		key_text.show()
		if Input.is_action_just_pressed("interact"):
			collider.interact()
	else:
		key_text.hide()


func _play_movement_animation() -> void:
	if is_running:
		_play_animation("running")
	else:
		_play_animation("walking")


func _play_animation(animation_name: StringName) -> void:
	if animation_player.current_animation != animation_name:
		animation_player.play(animation_name)


func _update_camera_bob(delta: float, direction: Vector3) -> void:
	var is_moving := direction.length() > 0.1 and is_on_floor()
	if is_moving:
		bob_time += delta * (2.0 if is_running else 1.2)
		var bob_strength := 0.05 if is_running else 0.03
		camera_mount.position.y = base_camera_position.y + sin(bob_time * 8.0) * bob_strength
		camera_mount.position.x = base_camera_position.x + cos(bob_time * 4.0) * bob_strength * 0.5
	else:
		bob_time = 0.0
		camera_mount.position = camera_mount.position.lerp(base_camera_position, 0.1)


func _hide_from_first_person_camera(node: Node) -> void:
	if node is VisualInstance3D:
		node.layers = FIRST_PERSON_HIDDEN_LAYER

	for child in node.get_children():
		_hide_from_first_person_camera(child)


func _set_flashlight_visible(visible: bool) -> void:
	flashlight.visible = visible

func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
