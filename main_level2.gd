class_name MainLevel2
extends Node

@onready var coin_label: Label = $HUD/CoinLabel
@onready var player: CharacterBody2D = $Player

func _ready() -> void:
	if player and player.has_signal(&"coin_collected"):
		player.connect(&"coin_collected", _on_coin_collected)

func _on_coin_collected(count: int) -> void:
	coin_label.text = "Level 2  |  Coins: %d" % count
