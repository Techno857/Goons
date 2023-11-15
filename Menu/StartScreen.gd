extends Control
@onready var bgm = $AudioStreamPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	bgm.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_start_pressed():
	get_tree().change_scene_to_file("res://World/world.tscn")
