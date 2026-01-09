extends Node3D
"""
Generator for spawning the walls, spawns based on actively ramps up 
the speed and varies the height and difficulity of the spawns
"""

## @deprecated
@export var projectile: PackedScene = preload("uid://cfirhu1gauwe5")

@export var projectiles: Array[PackedScene]
@export var projectile_speed: float = 20

## The longest amount of time it takes to spawn a projectile
@export var max_spawn_interval: float = 1.0
## The longest amount of time it takes to spawn a projectile
@export var min_spawn_interval: float = 0.1
## The speed at which difficulity increases. represented in SECONDS
## [br]i.e: 1 = every 1 second, 2 = every 2 seconds ... 
@export var difficulity_interval_rate: int = 5
@export var projectile_increase_speed: float = 1

@onready var spawner: Node3D = $Spawner
var current_time_speed: float = self.max_spawn_interval
signal increase_difficultiy

func _ready() -> void:
	#var spawner: Node3D = $Spawner
	self.spawner.set_projectile_speed(self.projectile_speed)
	self.spawner.projectile = self.projectile
	self.spawner.projectiles = self.projectiles
	self.spawner.set_strategy(MultiProjectileStrategy.new(), self.projectiles)
	
	self.increase_difficultiy.connect(self._increase_difficultiy)
	self.spawner.custom_code = self.increase_difficultiy

## Custom function to increase the difficulity after the timeout is called
## [br]
## Increases the difficulity of the projectile spawn rate by 0.1 every 5 seconds.
## Goes to a min of [member min_spawn_interval]
func _increase_difficultiy(total_time_elapsed: float) -> void:
	# Skip iterations if already at the fastest speed
	if self.current_time_speed == self.min_spawn_interval:
		return
	
	# Every interval of 5 (every 5 seconds), increase the difficulity 
	if (int(total_time_elapsed) % self.difficulity_interval_rate) == 0:
		var timer: Timer = $Spawn_Timer
		
		timer.wait_time = clampf(timer.wait_time - 0.025, self.min_spawn_interval, self.max_spawn_interval)
		current_time_speed = timer.wait_time
		self.spawner.set_projectile_speed(self.spawner.get_projectile_speed() + self.projectile_increase_speed)
		
