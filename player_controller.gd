class_name PlayerController
extends CharacterBody2D

signal coin_collected(count: int)

@export var speed: float = 400.0
@export var jump_velocity: float = -800.0
@export var coyote_time: float = 0.12
@export var jump_buffer_time: float = 0.12

@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var jump_audio: AudioStreamPlayer2D = $JumpAudio

var _coyote_timer: float = 0.0
var _jump_buffer_timer: float = 0.0
var _spawn_point: Vector2 = Vector2.ZERO
var coins: int = 0

func _ready() -> void:
	_spawn_point = global_position

func _physics_process(delta: float) -> void:
	# Coyote timer & Jump buffer timer
	if is_on_floor():
		_coyote_timer = coyote_time
	else:
		_coyote_timer = maxf(0.0, _coyote_timer - delta)
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("jump"):
		_jump_buffer_timer = jump_buffer_time
	else:
		_jump_buffer_timer = maxf(0.0, _jump_buffer_timer - delta)

	# Jump execution
	if _jump_buffer_timer > 0.0 and _coyote_timer > 0.0:
		velocity.y = jump_velocity
		_jump_buffer_timer = 0.0
		_coyote_timer = 0.0
		if jump_audio:
			jump_audio.play()

	# Variable jump height: release early to cut jump
	if Input.is_action_just_released("jump") and velocity.y < 0:
		velocity.y *= 0.5

	# Horizontal movement
	var direction := Input.get_axis("left", "right")
	if direction != 0:
		velocity.x = direction * speed
		animated_sprite.flip_h = direction < 0
	else:
		velocity.x = move_toward(velocity.x, 0.0, speed)

	# Animations
	_update_animation()

	move_and_slide()

	# Fall check / Respawn
	if global_position.y > 1000.0:
		respawn()

func _update_animation() -> void:
	if is_on_floor():
		if absf(velocity.x) > 10.0:
			animated_sprite.play(&"walk")
		else:
			animated_sprite.play(&"idle")
	else:
		if velocity.y < 0.0:
			animated_sprite.play(&"jump")
		else:
			animated_sprite.play(&"fall")

func collect_coin() -> void:
	coins += 1
	coin_collected.emit(coins)

func respawn() -> void:
	velocity = Vector2.ZERO
	global_position = _spawn_point
