class_name Bullet extends CharacterBody2D
# No direct collision child, hits are handled by Hitbox component


var speed: float = 400.0
var direction: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:
	velocity = direction * speed
	move_and_slide()
