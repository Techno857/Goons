extends CharacterBody2D

@export var speed: int = 200
@onready var animations = $AnimationPlayer
@onready var pistol = $"../SupPistol"
@onready var direction = "right"
#----------Enemy_Stuff-------------#
var enemy_inattackrange = false
var enemy_cooldown = true
var health = 100
var player_alive = true
#-------------Attack_shid--------------------#
var gun_equipped = true
var gun_cooldown = true
#---------Combat-----------------#
var attack_ip = false
#--------------------------------#
var bullet_speed = 500
var bullet = preload("res://bullet/Bullet.tscn")

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
	enemy_attack()
	if health <= 0:
		player_alive = false
		get_tree().change_scene_to_file("res://World/world.tscn")
		print("player dead")
		
	if pistol.magSize == 0:
		pistol.gunAcquired = false
		
	var mouse_pos = get_global_mouse_position()
	$Muzzle.look_at(mouse_pos)
	
	if Input.is_action_just_pressed("LMB") && pistol.gunAcquired && pistol.magSize > 0:
		fire()
		pistol.magSize -= 1
		

func _on_hurt_box_area_entered(area):
	if area.has_method("openDoor") && area.doorClosed:
		area.openDoor()

func fire():
	var bullet_instance = bullet.instantiate() 
	bullet_instance.position = get_global_position()
	bullet_instance.transform = $Muzzle.global_transform
	bullet_instance.rotation_degrees = rotation_degrees
	bullet_instance.linear_velocity = Vector2(bullet_speed,0).rotated(rotation)
	get_tree().get_root().call_deferred("add_child",bullet_instance)


func _on_player_hitbox_body_entered(body):
	if body.has_method("grunt"):
		enemy_inattackrange = true


func _on_player_hitbox_body_exited(body):
	if body.has_method("grunt"):
		enemy_inattackrange = false

func enemy_attack():
	if enemy_inattackrange and enemy_cooldown == true:
		health = 0
		enemy_cooldown = false
		$attack_cooldown.start()
		print(health)


func _on_attack_cooldown_timeout():
	enemy_cooldown = true

