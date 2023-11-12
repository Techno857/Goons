extends CharacterBody2D

@export var speed: int = 200
@onready var animations = $AnimationPlayer
@onready var pistol = $"../SupPistol"
@onready var direction = "right"


var bullet_speed = 500
var bullet = preload("res://SuppPistol/Bullet.tscn")

func handleInput():
	var moveDirection = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	velocity = moveDirection*speed

func updateAnimation():
	if velocity.length() == 0:
		animations.stop()
	elif pistol.gunAcquired:
		animations.play("goon_gun_walk")
		$Goon.hide()
		$GoonCollision.hide()
		$GoonGun.show()
		$GoonGunCollision.show()
	else:
		animations.play("goon_walk")
		$GoonGun.hide()
		$GoonGunCollision.hide()
		$Goon.show()
		$GoonCollision.show()
	

	# # Diagonal movements
	# if  velocity.x < 0 && velocity.y < 0: direction = "up_left"
	# elif  velocity.x < 0 && velocity.y > 0: direction = "down_left"
	# elif  velocity.x > 0 && velocity.y < 0: direction = "up_right"
	# elif  velocity.x > 0 && velocity.y > 0: direction = "down_right"
	
	# # Cardinal movements
	# elif velocity.x < 0: direction = "left"
	# elif  velocity.x > 0: direction = "right"
	# elif  velocity.y < 0: direction = "up"
	# elif  velocity.y > 0: direction = "down"

	# animations.play("goon_walk_"+ direction)

func _physics_process(_delta):

	handleInput()
	move_and_slide()
	# updateAnimation()
	updateAnimation()
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("LMB") && pistol.gunAcquired && pistol.magSize > 0:
		fire()
		pistol.magSize -= 1
		
	if pistol.magSize == 0:
		pistol.gunAcquired = false

func _on_hurt_box_area_entered(area):
	if area.has_method("openDoor") && area.doorClosed:
		area.openDoor()

func fire():
	var bullet_instance = bullet.instantiate() 
	bullet_instance.position = get_global_position()
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.linear_velocity = Vector2(bullet_speed,0).rotated(rotation)
	get_tree().get_root().call_deferred("add_child",bullet_instance)
