class_name Enemy extends Entity


enum EnemyState {
	IDLE,
	MOVING,
	JUMPED,
	ATTACKED,
	#PARRY,
}


@export var player: Player:
	get:
		if not player:
			player = get_tree().get_first_node_in_group("Player")
		return player


var current_state: EnemyState = EnemyState.IDLE


@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D


func _physics_process(delta: float) -> void:
	super(delta)
	_handle_states(delta)
	_apply_gravity(delta)
	_enemy_sprite_face()

	move_and_slide()


func _handle_states(delta) -> void:
	# Process states
	match current_state:
		EnemyState.IDLE: _process_idle()
		EnemyState.MOVING: _process_moving()
		EnemyState.ATTACKED: _process_attacked()
		EnemyState.JUMPED: _process_attacked()

	time_since_attack += delta
	can_attack = true if time_since_attack >= attack_speed else false

	# Transition states
	if can_attack:
		current_state = EnemyState.ATTACKED
	#elif Input.is_action_just_pressed("jump") and is_on_floor():
		#current_state = EnemyState.JUMPED
	else:
		current_state = EnemyState.MOVING
	#else:
		#current_state = EnemyState.IDLE


func _process_idle() -> void:
	pass


func _process_moving() -> void:
	direction = -1.0 if player.global_position.x < position.x else 1.0
	velocity.x = direction * move_speed


func _process_attacked() -> void:
	time_since_attack = 0.0
	weapon.attack()


func _process_jumped() -> void:
	pass


func _apply_gravity(delta: float) -> void:
	if is_on_floor():
		air_time = 0.0
	else:
		air_time += delta * descent_speed

	# Apply gravity
	velocity.y = lerp(velocity.y, get_gravity().y * min(air_time, max_descent_speed), delta)


func _enemy_sprite_face() -> void:
	# Sprite faces player
	sprite.flip_h = player.global_position.x < position.x
