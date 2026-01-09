extends StaticBody3D
@export var speed = 20


func _process(delta: float) -> void:
	position.z += speed * delta

func _on_timer_timeout() -> void:
	queue_free()
