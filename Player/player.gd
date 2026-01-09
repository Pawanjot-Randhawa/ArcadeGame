extends CharacterBody3D
class_name Player


@export var SPEED = 5.0
@export var JUMP_VELOCITY = 4.5
@export var gravity_down = 1
@export var gravity_up = 1
#temp
@onready var ball: CollisionShape3D = $ball
@onready var ball_mesh: MeshInstance3D = $ballMesh
@onready var cylinder: CollisionShape3D = $cylinder
@onready var cylinder_mesh: MeshInstance3D = $cylinderMesh


@onready var crouch_timer: Timer = $"Crouch Timer"

var crouching : bool = false

func _physics_process(delta: float) -> void:
	if crouching:
		return
	# Add the gravity.
	if not is_on_floor():
		if velocity.y > 0:
			velocity += get_gravity() * gravity_down * delta

		elif velocity.y <= 0:
			velocity += get_gravity() * gravity_up * delta
	

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir := Input.get_vector("move_left", "move_right", "move_forward", "move_back")
	var direction := (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
	if Input.is_action_just_pressed("crouch"):
		set_crouch()
		
	move_and_slide()

func set_crouch():
	crouch_timer.start()
	crouching = true
	cylinder_mesh.visible = false
	ball_mesh.visible = true
	cylinder.set_deferred("disabled", false)
	ball.set_deferred("disabled", true)


func _on_crouch_timer_timeout() -> void:
	cylinder_mesh.visible = true
	ball_mesh.visible = false
	ball.set_deferred("disabled", false)
	cylinder.set_deferred("disabled", true)
	crouching = false
