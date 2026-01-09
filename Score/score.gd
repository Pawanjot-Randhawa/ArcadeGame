extends Node3D

@export var label: Label
@export var score_increase: int
var score: int = 0


func _on_score_timer_timeout() -> void:
	self.score += self.score_increase
	# Update the label
	if self.label:
		self.label.text = str(self.score)
