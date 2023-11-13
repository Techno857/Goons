extends CharacterBody2D

@onready var animation_sprite = $AnimatedSprite2D

#-----------Health-------------#
var health = 100
var player_inattackzone = false
var can_take_damage

var speed = 25
var player_chase = false
var player = null

func _physics_process(delta):	
	if player_chase:
		position += (player.position - position)/speed
		$AnimatedSprite2D.play("walk")
		move_and_collide(Vector2(0,0))
		if(player.position.x - position.x) < 0:
			$AnimatedSprite2D.flip_h = true
		else:
			$AnimatedSprite2D.flip_h = false
	else:
		$AnimatedSprite2D.play("idle")
		
func _on_detection_area_body_entered(body):
	player = body
	player_chase = true


func _on_detection_area_body_exited(body):
	player = null
	player_chase = false

func grunt():
	pass

func _on_enemy_hitbox_body_entered(body):
	if body.has_method("pierce"):
		queue_free()

func _on_enemy_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattackzone = false
		

