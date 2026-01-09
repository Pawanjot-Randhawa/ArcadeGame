class_name Spawner extends Node3D

@export var projectile: PackedScene
@export var pivot: Node3D
@export var spawn_timer: Timer
@export var custom_code: Signal

var total_time_elapsed: float 
## Kill any spawned projectile after 5 seconds if there isn't 
## a method to already handle it
var safe_kill_projectile_time: float = 5.0 

func _ready() -> void:
	if self.spawn_timer:
		self.spawn_timer.timeout.connect(self.spawn)
	

func spawn() -> void:
	self.total_time_elapsed += self.spawn_timer.wait_time
	
	var temp = projectile.instantiate()
	if not temp.has_method("_on_timer_timeout"):
		var kill_timer: Timer = Timer.new()
		
		kill_timer.wait_time = self.safe_kill_projectile_time
		kill_timer.autostart = true
		
		kill_timer.timeout.connect(queue_free)
		temp.add_child(kill_timer)
		
	if self.pivot:
		self.pivot.add_child(temp)
	else:
		self.add_child(temp)
	
	if self.custom_code:
		self.custom_code.emit(self.total_time_elapsed)
