class_name Spawner extends Node3D

## @deprecated
@export var projectile: PackedScene

@export var projectiles: Array[PackedScene]
@export var pivot: Node3D
@export var spawn_timer: Timer
@export var custom_code: Signal
@export var projectile_speed: float

var strategy: SpawnProjectileStrategy = SingleProjectileStrategy.new()
var total_time_elapsed: float 
## Kill any spawned projectile after 5 seconds if there isn't 
## a method to already handle it
var safe_kill_projectile_time: float = 5.0 

func _ready() -> void:
	if self.spawn_timer:
		self.spawn_timer.timeout.connect(self.spawn)

func set_projectile_speed(speed: float) -> void:
	self.projectile_speed = speed

func get_projectile_speed() -> float:
	return self.projectile_speed

func set_strategy(strategy: SpawnProjectileStrategy, scenes) -> void:
	self.strategy = strategy
	self.strategy.set_projectiles(scenes)

func spawn() -> void:
	self.total_time_elapsed += self.spawn_timer.wait_time
	
	var temp = self.strategy.get_projectile()
	temp.speed = self.projectile_speed
	
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
