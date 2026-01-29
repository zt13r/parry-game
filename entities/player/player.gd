class_name Player extends Entity


enum PlayerState {
	IDLE,
	MOVING,
	JUMPED,
	ATTACKED,
	ACTIVATED_SKILL_ONE,
	ACTIVATED_SKILL_TWO,
	ACTIVATED_ULTIMATE_SKILL,
	PARRY,
}


@export var parry_strength: float = 0.0 ## Damage reflected after a successful parry
@export var weapon_pos_distance: float = 50.0 ## How far weapon is placed from the player


var current_state: PlayerState = PlayerState.IDLE ## Used for player processing and transition

var weapon_dir: Vector2 = Vector2.ZERO ## Helps with attacking direction


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	super()

	if not is_in_group("Player"):
		add_to_group("Player")

	_initialize_weapon()


func _physics_process(delta: float) -> void:
	super(delta)
	_handle_states(delta)
	_apply_gravity(delta)
	_weapon_sprite_rotation()
	_player_sprite_face()

	move_and_slide()


func _handle_states(delta: float) -> void:
	# Process states
	match current_state:
		PlayerState.IDLE: _process_idle()
		PlayerState.MOVING: _process_moving()
		PlayerState.JUMPED: _process_jumped()
		PlayerState.ATTACKED: _process_attacked()
		PlayerState.ACTIVATED_SKILL_ONE: _process_skill_one()
		PlayerState.ACTIVATED_SKILL_TWO: _process_skill_two()
		PlayerState.ACTIVATED_ULTIMATE_SKILL: _process_ultimate_skill()
		PlayerState.PARRY: _process_parry()

	# Get player left and right movement
	direction = Input.get_axis("move_left", "move_right")

	# Attacking condition
	time_since_attack += delta
	can_attack = true if time_since_attack >= attack_speed else false

	# Transition states
	if Input.is_action_just_pressed("skill_ultimate"):
		current_state = PlayerState.ACTIVATED_ULTIMATE_SKILL
	elif Input.is_action_just_pressed("skill_two"):
		current_state = PlayerState.ACTIVATED_SKILL_TWO
	elif Input.is_action_just_pressed("skill_one"):
		current_state = PlayerState.ACTIVATED_SKILL_ONE
	elif Input.is_action_pressed("attack") and can_attack:
		current_state = PlayerState.ATTACKED
	elif Input.is_action_just_pressed("jump") and is_on_floor():
		current_state = PlayerState.JUMPED
	elif direction != 0.0:
		current_state = PlayerState.MOVING
	else:
		current_state = PlayerState.IDLE


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


func _initialize_weapon() -> void:
	weapon.apply_multipliers()


func _process_idle() -> void:
	if velocity.x != 0.0:
		velocity.x = 0.0


func _process_moving() -> void:
	velocity.x = direction * move_speed


func _process_jumped() -> void:
	velocity.y -= jump_height


func _process_attacked() -> void:
	time_since_attack = 0.0
	weapon.attack()


func _process_skill_one() -> void:
	pass


func _process_skill_two() -> void:
	pass


func _process_ultimate_skill() -> void:
	pass


func _process_parry() -> void:
	pass


func _weapon_sprite_rotation() -> void:
	# Sets weapon_sprite position to be around the player at weapon_pos_distance
	weapon_dir = (get_global_mouse_position() - global_position).normalized() * weapon_pos_distance
	weapon.position = weapon_dir


func _player_sprite_face() -> void:
	# Sprite faces mouse position
	sprite.flip_h = get_global_mouse_position().x < position.x
