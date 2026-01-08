extends Node3D


@onready var jump_spawn: Marker3D = $JumpSpawn
const jumper : PackedScene = preload("uid://cfirhu1gauwe5")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_lava_kill_zone_body_entered(body: Node3D) -> void:
	if body is Player:
		pass


func _on_jump_spawner_timeout() -> void:
	var temp = jumper.instantiate()
	temp.position
	jump_spawn.add_child(temp)
