extends Node
class_name AbilityButtonUI

signal abilityQueued(initiatorId:String)

@onready var cooldownUI:ProgressBar = $InnerBox/Cooldown
@onready var border_active = $Border/Active
@onready var abilityIcon = $InnerBox/TextureRect
@onready var label = $InnerBox/Label

@export var hotKey := "ability 1"
@export var cooldownTime:float = 4
@export var texture:Texture
@export var text:String

var id:String
var _currentCooldown:float = 0
var currentCooldown:float:
	get:
		return _currentCooldown
	set(val):
		_currentCooldown = val
		_currentCooldown = maxf(val, 0)
		cooldownUI.value = _currentCooldown

var _abilityActive := false
var abilityActive:bool:
	get:
		return _abilityActive
	set(val):
		_abilityActive = val
		border_active.visible = _abilityActive

# Called when the node enters the scene tree for the first time.
func initialize():
	cooldownUI.max_value = cooldownTime
	abilityIcon.texture = texture
	label.text = text
	id = hotKey
	pass # Replace with function body.

func _input(event):
	if currentCooldown != 0:
		return
	if event.is_action(hotKey):
		queueAbility()
	if event.is_action("shoot"):
		useAbility()
	if event.is_action("cancelAbility"):
			abilityActive = false
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func startCooldown():
	abilityActive = false
	currentCooldown = cooldownTime
	pass
func useAbility():
	if abilityActive:
		startCooldown()
	pass
func queueAbility():
	if abilityActive || currentCooldown > 0:
		return
	abilityActive = true
	abilityQueued.emit(id)
	pass
func _process(delta):
	currentCooldown -= delta
	pass
func cancelQueue():
	abilityActive = false
