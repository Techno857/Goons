extends CharacterBody2D

@export var speed: int = 200
@onready var animations = $AnimationPlayer
@onready var direction = "right"

var bullet_speed = 1000
var bullet = preload("res://World/Bullet.tscn")

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

func singleAnimation():
	if velocity.length() == 0:
		animations.stop()
	
	else:
		animations.play("goon_walk")

func _physics_process(_delta):
	handleInput()
	move_and_slide()
	# updateAnimation()
	singleAnimation()
	look_at(get_global_mouse_position())

	if Input.is_action_just_pressed("LMB"):
		fire()

func _on_hurt_box_area_entered(area):
	if area.has_method("openDoor") && area.doorClosed:
		area.openDoor()

func fire():
	var bullet_instance = bullet.instantiate() 
	bullet_instance.position = get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.apply_impulse(Vector2(),Vector2(bullet_speed,0).rotated(rotation))
	get_tree().get_root().call_deferred("add_child",bullet_instance)
