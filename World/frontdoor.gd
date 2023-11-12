extends Area2D

@onready var tilemap = $"../TileMap"
@onready var doorClosed = true

func openDoor():
	doorClosed = false
	tilemap.set_layer_enabled(2, false)
