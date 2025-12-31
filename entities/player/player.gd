class_name Player extends Entity


enum State {
	IDLE,
	MOVING,
	JUMPED,
	ATTACKING,
	PARRYING,
}


@export var parry_strength: float = 0.0 ## Damage reflected after a successful parry


var current_state: State = State.IDLE ## Used for player processing and transition

var direction: float = 0.0 ## Movement variable

var air_time: float = 0.0 ## Gravity/descent helper


func _ready() -> void:
	add_to_group("Entities")


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)

	# Process states
	match current_state:
		State.IDLE: _process_idle()
		State.MOVING: _process_moving()
		State.JUMPED: _process_jumped()
		State.ATTACKING: _process_attacking()
		State.PARRYING: _process_parrying()

	# Get player left and right movement
	direction = Input.get_axis("move_left", "move_right")

	# Transition states
	if Input.is_action_just_pressed("jump") and is_on_floor():
		current_state = State.JUMPED
	elif direction != 0.0:
		current_state = State.MOVING
	else:
		current_state = State.IDLE

	move_and_slide()


func _process_idle() -> void:
	if velocity.x != 0.0:
		velocity.x = 0.0


func _process_moving() -> void:
	velocity.x = direction * move_speed


func _process_jumped() -> void:
	velocity.y -= jump_height


func _process_attacking() -> void:
	pass


func _process_parrying() -> void:
	pass


func _apply_gravity(delta: float) -> void:
	if is_on_floor():
		air_time = 0.0
	else:
		air_time += delta * descent_speed

	# Heavier gravity if pressing down
	if Input.is_action_pressed("move_down"):
		air_time = max_descent_speed
	air_time = min(air_time, max_descent_speed)

	# Apply gravity
	velocity.y = lerp(velocity.y, get_gravity().y * air_time, delta)
