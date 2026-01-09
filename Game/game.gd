extends Node3D


@onready var spawn_point: Marker3D = $SpawnPoint

const jumper : PackedScene = preload("uid://cfirhu1gauwe5")
const croucher : PackedScene = preload("uid://24qwustr7ftx")

@export var obstacles : Array[PackedScene] = []


func _on_lava_kill_zone_body_entered(body: Node3D) -> void:
	if body is Player:
		pass


func _on_spawner_timeout() -> void:
	var holder = obstacles[randi() % obstacles.size()]
	var obstacle = holder.instantiate()
	spawn_point.add_child(obstacle)

func death(body : Node3D):
	if body is Player:
		print("hit")
