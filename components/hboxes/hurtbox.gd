class_name Hurtbox extends Area2D
# SHOULD HAVE COLLISION CHILD OUT OF SCENE !!! or it won't work, obviously


@export var actor: CharacterBody2D:
	get:
		if not actor:
			actor = get_parent()
		return actor


func apply_damage(points: float) -> void:
	actor.damage(points)
