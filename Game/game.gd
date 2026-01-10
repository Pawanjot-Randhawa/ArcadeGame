extends Node3D


@onready var spawn_point: Marker3D = $SpawnPoint
@onready var spawner: Timer = $Spawner
@onready var round_timer: Timer = $RoundTimer

#UI vars
@onready var ui: Control = $UI
@onready var score_container: MarginContainer = $MarginContainer
@onready var score_label: Label = $MarginContainer/VBoxContainer/score
@onready var highscore_label: Label = $UI/MarginContainer2/Highscore
@onready var start_prompt: Label = $UI/start_prompt
@onready var highscore_2: Label = $MarginContainer/VBoxContainer/highscore2

const jumper : PackedScene = preload("uid://cfirhu1gauwe5")
const croucher : PackedScene = preload("uid://24qwustr7ftx")

@onready var player: Player = $Player
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var obstacles : Array[PackedScene] = []

var ingame : bool = false
var highscore : int = 0:
	set(value):
		highscore = value
		highscore_label.text = "Highscore = " + str(highscore)
		highscore_2.text = str(highscore)
var score : int = 0:
	set(value):
		score = value
		score_label.text = str(score)

func _ready() -> void:
	player.position = Vector3(0,23,22)
	audio_stream_player.volume_db = -40.0

func _process(delta: float) -> void:
	if ingame:
		if score > highscore and highscore != 0:
			highscore_2.add_theme_color_override("font_color", Color(0.0, 0.591, 0.135, 1.0))
	if not ingame:
		if Input.is_action_just_pressed("enter"):
			ui.visible = false
			score_container.visible = true
			start_game()

func start_game():
	audio_stream_player.volume_db = -20.0
	ingame = true
	player.position = Vector3(0,1.05,0)
	spawner.start()
	round_timer.start()
	highscore_2.add_theme_color_override("font_color", Color(1.0,1.0,1.0,1.0))
	
func _on_lava_kill_zone_body_entered(body: Node3D) -> void:
	if body is Player:
		death()


func _on_spawner_timeout() -> void:
	var holder = obstacles[randi() % obstacles.size()]
	var obstacle = holder.instantiate()
	spawn_point.add_child(obstacle)

func death():
	audio_stream_player.volume_db = -40.0
	spawner.stop()
	round_timer.stop()
	if score > highscore:
		highscore = score
	score = 0
	ui.visible = true
	score_container.visible = false
	player.position = Vector3(0,23,22)
	ingame = false


func _on_round_timer_timeout() -> void:
	score += 10
