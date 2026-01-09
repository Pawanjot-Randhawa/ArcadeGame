class_name SingleProjectileStrategy extends SpawnProjectileStrategy

var projectile: PackedScene

func get_projectile() -> Node:
	return self.projectile.instantiate()

func set_projectiles(projectile: PackedScene) -> void:
	self.projectile = projectile
