class_name MovingPlatform
extends AnimatableBody2D

@export var move_distance: float = 200.0
@export var speed: float = 80.0
@export var move_horizontal: bool = true

var _start_pos: Vector2 = Vector2.ZERO
var _time: float = 0.0

func _ready() -> void:
	_start_pos = position

func _physics_process(delta: float) -> void:
	_time += delta * (speed / move_distance)
	var offset: float = (sin(_time * PI) * 0.5 + 0.5) * move_distance
	if move_horizontal:
		position.x = _start_pos.x + offset
	else:
		position.y = _start_pos.y + offset
