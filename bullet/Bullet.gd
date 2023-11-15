extends RigidBody2D

var speed = 500

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position += (Vector2.RIGHT*speed).rotated(rotation) * delta
	
func pierce():
	pass
	
func _on_visible_on_screen_enabler_2d_screen_exited():
	queue_free()
	
func _on_area_2d_body_entered(body):
	if body.has_method("grunt"):
		queue_free()
