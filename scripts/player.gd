class_name Player extends CharacterBody2D


enum State {
	IDLE,
	MOVING,
	JUMPING,
	FALLING,
	ATTACKING,
	PARRYING,
}


@export_group("Speed Parameters")
@export var move_speed: float = 200.0 # Directional (x) movement speed
@export var attack_speed: float = 0.0 # Weapon attack speed
@export var parry_speed: float = 0.0 # Speed at which player can parry attacks

@export_group("Strength Parameters")
@export var attack_damage: float = 0.0 # Player attack strength
@export var parry_strength: float = 0.0 # Damage reflected after a successful parry
@export var jump_height: float = 200.0


var current_state: State = State.IDLE # Used for player processing and transition

var direction: float = 0.0                    # Movement variable


func _ready() -> void:
	add_to_group("Entities")


func _physics_process(_delta: float) -> void:
	# Process states
	match current_state:
		State.IDLE: _process_idle()
		State.MOVING: _process_moving()
		State.JUMPING: _process_jumping()
		State.FALLING: _process_falling()
		State.ATTACKING: _process_attacking()
		State.PARRYING: _process_parrying()

	direction = Input.get_axis("move_left", "move_right")

	# Transition states
	if Input.is_action_just_pressed("jump") and is_on_floor():
		current_state = State.JUMPING
	elif direction != 0:
		current_state = State.MOVING
	elif not is_on_floor():
		current_state = State.FALLING
	else:
		current_state = State.IDLE

	move_and_slide()
	print(current_state)


func _process_idle() -> void:
	if velocity.x != 0:
		velocity.x = 0


func _process_moving() -> void:
	velocity.x = move_toward(velocity.x, direction * move_speed, 1)


func _process_jumping() -> void:
	velocity.y += jump_height


func _process_falling() -> void:
	velocity.y -= get_gravity().y


func _process_attacking() -> void:
	pass


func _process_parrying() -> void:
	pass
