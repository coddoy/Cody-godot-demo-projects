class_name Bullet
extends RigidBody3D
@onready var sphere = $Sphere

## If `true`, the bullet can hit enemies. This is set to `false` when the bullet
## hits an enemy so it can't hit an enemy multiple times while the bullet is fading out.
var enabled := true

func _ready():
	var material: Material= sphere.material_override
	material.Color
	
