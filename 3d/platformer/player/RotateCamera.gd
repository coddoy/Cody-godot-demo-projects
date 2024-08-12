extends Camera3D
#
#const MAX_HEIGHT = 2.0
#const MIN_HEIGHT = 0.0
#
#var collision_exception: Array[RID] = []
#
@export var distance := 0.5
@export var invertY := true
#@export var angle_v_adjust := 0.0
#@export var autoturn_ray_aperture := 25.0
#@export var autoturn_speed := 50.0

@export_range(0.0, 1.0) var sensitivity: float = 0.25

signal cameraYawChanged(deltaAngle:float)

# Mouse state
var _mouse_position = Vector2(0.0, 0.0)
var _total_pitch = 0.0

# Updates mouselook and movement every frame
func _process(delta):
	_update_mouselook()
	pass

# Updates mouse look 
func _update_mouselook():
	var target := (get_parent() as Node3D)
	# Only rotates mouse if the mouse is captured
	if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
		_mouse_position *= sensitivity
		var yaw = _mouse_position.x
		var pitch = _mouse_position.y
		if invertY:
			pitch *=-1
		_mouse_position = Vector2(0, 0)
		
		# Prevents looking up/down too far
		pitch = clamp(pitch, -80 - _total_pitch, -10 - _total_pitch)
		_total_pitch += pitch
		var deltaAngle = -yaw
		cameraYawChanged.emit(deltaAngle)
		target.rotate_object_local(Vector3(1,0,0), deg_to_rad(pitch))
	
func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
func _input(event):
	if event is InputEventMouseMotion:
		_mouse_position = event.relative
	if event.is_action_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	if event.is_action_pressed("shoot"): #click back in screen
		if Input.get_mouse_mode() == Input.MOUSE_MODE_VISIBLE:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
			get_viewport().set_input_as_handled()
	pass
func UpdatePosition() -> void:
	var target := (get_parent() as Node3D).position
	var newPos = target - rotation.normalized() * distance
	position = newPos
	#var pos := get_global_transform().origin
	#var difference := pos - target

	# Regular delta follow.

	## Check autoturn.
	#var ds := PhysicsServer3D.space_get_direct_state(get_world_3d().get_space())
#
	#var col_left := ds.intersect_ray(PhysicsRayQueryParameters3D.create(
			#target,
			#target + Basis(Vector3.UP, deg_to_rad(autoturn_ray_aperture)) * (difference),
			#0xffffffff,
			#collision_exception
	#))
	#var col := ds.intersect_ray(PhysicsRayQueryParameters3D.create(
			#target,
			#target + difference,
			#0xffffffff,
			#collision_exception
	#))
	#var col_right := ds.intersect_ray(PhysicsRayQueryParameters3D.create(
			#target,
			#target + Basis(Vector3.UP, deg_to_rad(-autoturn_ray_aperture)) * (difference),
			#0xffffffff,
			#collision_exception
	#))
#
	#if not col.is_empty():
		## If main ray was occluded, get camera closer, this is the worst case scenario.
		#difference = col.position - target
	#elif not col_left.is_empty() and col_right.is_empty():
		## If only left ray is occluded, turn the camera around to the right.
		#difference = Basis(Vector3.UP, deg_to_rad(-delta * (autoturn_speed))) * difference
	#elif col_left.is_empty() and not col_right.is_empty():
		## If only right ray is occluded, turn the camera around to the left.
		#difference = Basis(Vector3.UP, deg_to_rad(delta * autoturn_speed)) * difference
	## Do nothing otherwise, left and right are occluded but center is not, so do not autoturn.
#
	## Apply lookat.
	#if difference.is_zero_approx():
		#difference = (pos - target).normalized() * 0.0001
#
	#pos = target + difference
#
	#look_at_from_position(pos, target, Vector3.UP)
#
	## Turn a little up or down.
	#transform.basis = Basis(transform.basis[0], deg_to_rad(angle_v_adjust)) * transform.basis
	pass
