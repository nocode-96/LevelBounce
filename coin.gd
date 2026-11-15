class_name Coin
extends Area2D

@onready var audio: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D

var _collected: bool = false
var _float_time: float = 0.0

func _ready() -> void:
	body_entered.connect(_on_body_entered)

func _process(delta: float) -> void:
	_float_time += delta * 3.0
	sprite.position.y = sin(_float_time) * 4.0

func _on_body_entered(body: Node2D) -> void:
	if _collected:
		return
	if body.has_method(&"collect_coin"):
		_collected = true
		body.call(&"collect_coin")
		collision.set_deferred("disabled", true)
		sprite.visible = false
		audio.play()
		await audio.finished
		queue_free()
