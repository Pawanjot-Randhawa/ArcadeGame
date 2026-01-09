class_name MultiProjectileStrategy extends SpawnProjectileStrategy

var projectiles: Array[PackedScene]

func get_projectile() -> Node:
	return projectiles[randi() % self.projectiles.size()].instantiate()

func set_projectiles(projectiles: Array[PackedScene]) -> void:
	self.projectiles = projectiles
