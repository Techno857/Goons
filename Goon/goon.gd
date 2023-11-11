extends CharacterBody2D

@export var speed: int = 200
@onready var animations = $AnimationPlayer
@onready var direction = "right"



func handleInput():
	var moveDirection = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = moveDirection*speed

func updateAnimation():
	if velocity.length() == 0:
		animations.stop()

	# Diagonal movements
	if  velocity.x < 0 && velocity.y < 0: direction = "up_left"
	elif  velocity.x < 0 && velocity.y > 0: direction = "down_left"
	elif  velocity.x > 0 && velocity.y < 0: direction = "up_right"
	elif  velocity.x > 0 && velocity.y > 0: direction = "down_right"
	
	# Cardinal movements
	elif velocity.x < 0: direction = "left"
	elif  velocity.x > 0: direction = "right"
	elif  velocity.y < 0: direction = "up"
	elif  velocity.y > 0: direction = "down"

	animations.play("goon_walk_"+ direction)

func _physics_process(_delta):
	handleInput()
	move_and_slide()
	updateAnimation()
