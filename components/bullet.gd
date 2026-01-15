class_name Projectile extends CharacterBody2D
# No direct collision child, hits are handled by Hitbox component


var speed: float = 20.0
var damage: float = 0.0
var direction: Vector2 = Vector2.ZERO

var fired_by: Entity = null


func _physics_process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()
