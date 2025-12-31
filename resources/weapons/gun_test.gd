class_name GunTest extends Weapon


const BULLET: PackedScene = preload("res://components/bullet.tscn")


func attack(dir: Vector2) -> void:
	var bullet: Bullet = BULLET.instantiate()
	bullet.direction = dir
	bullet.global_position = player.weapon_sprite.global_position
	player.get_tree().root.add_child(bullet)
