extends Camera3D
#
@export var max_zoom := 10
@export var min_zoom := 0
@export var zoom_speed := 0.3

@export var distance := 0.5
@export var invertY := true

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
	if event.is_action_pressed("zoom in"):
		position.z-=zoom_speed
		position.z = max(min_zoom,position.z)
	if event.is_action_pressed("zoom out"):
		position.z+=zoom_speed
		position.z = min(max_zoom,position.z)
	pass
func UpdatePosition() -> void:
	var target := (get_parent() as Node3D).position
	var newPos = target - rotation.normalized() * distance
	position = newPos
	pass
