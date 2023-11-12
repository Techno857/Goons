extends Area2D

var gunAcquired = false

func pickUpGun():
	gunAcquired = true
	
func _on_area_entered(area):
	pickUpGun()
	$GunSprite.visible = false
