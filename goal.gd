class_name Goal
extends Area2D

@export_file("*.tscn") var next_scene_path: String = ""
@export var is_final_goal: bool = false

@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sprite: Sprite2D = $Sprite2D

var _triggered: bool = false
var _float_time: float = 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	_float_time += delta * 2.5
	sprite.position.y = sin(_float_time) * 6.0
	sprite.rotation = sin(_float_time * 0.5) * 0.1

func _on_body_entered(body: Node2D) -> void:
	if _triggered:
		return
	if body.has_method(&"collect_coin"):
		_triggered = true
		if audio:
			audio.play()
		await get_tree().create_timer(0.3).timeout
		if next_scene_path != "":
			get_tree().change_scene_to_file(next_scene_path)
		elif is_final_goal:
			# Final level: restart from level 1
			get_tree().change_scene_to_file("res://main.tscn")
