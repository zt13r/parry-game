class_name Entity extends CharacterBody2D
# Putting here for no reason at all:
# To get root node: node.get_tree().root.get_child(0)


@export var immunity_frames: float = 0.9 ## Pauses hurtbox for immunity_frames time when hit

@export_group("Stats")
@export var health: float = 100.0 ## Entity health

# Still unsure whether or not to have enemies carry set or semi-randomized weapons (excluding bosses)
@export var weapon: Weapon = null ## Equipped weapon

@export_group("Speed Parameters")
@export var move_speed: float = 400.0 ## Directional (x) movement speed
@export var attack_speed: float = 1.0 ## Attack speed in seconds (player: affected by weapon and class)

# Still unsure whether or not to have enemies be able to parry
@export var parry_speed: float = 0.0 ## Speed at which player can parry attacks

@export_group("Strength Parameters")
@export var damage: float = 0.0 ## Attack strength (player: affected by weapon and class)

@export_group("Jump Parameters")
@export var jump_height: float = 500.0 ## Directional (y) jump velocity
@export var descent_speed: float = 2.5 ## Used for "realism"
@export var max_descent_speed: float = 10.0 ## Max descent speed, also used for "realism"


var direction: float = 0.0 ## Movement variable
var air_time: float = 0.0 ## Gravity/descent helper
var time_since_attack: float = 0.0 ## Attack speed thing
var time_since_last_hit: float = 0.0 ## Immunity frames stuff

var can_attack: bool = true


func _ready() -> void:
	if not is_in_group("Entities"):
		add_to_group("Entities")

	time_since_last_hit = 0.0


func _physics_process(delta: float) -> void:
	time_since_last_hit += delta


func hit(points: float) -> void:
	if _immunity_frames_active():
		#print("%s: Haha can't hit me, I have %.2fsec i-frames left" % [name, immunity_frames - time_since_last_hit])
		return

	health -= points
	time_since_last_hit = 0.0

	print("%s: %.2f hp -> %.2f hp" % [name, health + points, health])

	if health <= 0.0:
		die()


func die() -> void:
	queue_free()
	#pass


func _immunity_frames_active() -> bool:
	if time_since_last_hit <= immunity_frames:
		return true
	return false
