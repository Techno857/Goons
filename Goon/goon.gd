extends CharacterBody2D

@export var speed: int = 200
@onready var animations = $AnimationPlayer
@onready var pistol = $"../SupPistol"
@onready var knife = $Knife
@onready var knifeTimer = $Knife/knifeTimer
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

func _physics_process(_delta):

	handleInput()
	move_and_slide()
	updateAnimation()
	look_at(get_global_mouse_position())
	
	if Input.is_action_just_pressed("LMB") && pistol.gunAcquired && pistol.magSize > 0:
		fire()
		pistol.magSize -= 1
		
	if pistol.magSize == 0:
		pistol.gunAcquired = false
		
	if Input.is_action_just_pressed("RMB") && pistol.gunAcquired == false:
		knifeTimer.start()
		knife.visible = true
		knife.set_collision_mask_value(1, true)
		$KnifeStab.play()
		
		await knifeTimer.timeout
		
		knife.set_collision_mask_value(1, false)
		knife.visible = false
		
func fire():
	var bullet_instance = bullet.instantiate() 
	bullet_instance.position = get_global_position()
	bullet_instance.transform = $Muzzle.global_transform
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.linear_velocity = Vector2(bullet_speed,0).rotated(rotation)
	get_tree().get_root().call_deferred("add_child",bullet_instance)
	$SuppGunshot.play()
	
func _on_hurt_box_area_entered(area):
	if area.has_method("openDoor") && area.doorClosed:
		area.openDoor()

func _on_knife_area_entered(area):
	if area.has_method("openDoor") && area.doorClosed:
		area.openDoor()
