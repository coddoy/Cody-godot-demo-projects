extends Node
class_name AbilityButtonUI

signal abilityPlanned(initiatorId:String)

@onready var cooldownUI:ProgressBar = $InnerBox/Cooldown
@onready var border_active = $Border/Active
@onready var abilityIcon = $InnerBox/TextureRect
@onready var label = $InnerBox/Label

@export var hotKey := "ability 1"
@export var cooldownTime:float = 4
@export var texture:Texture
@export var text:String
@export var bullet:Resource

var id:String
var _currentCooldown:float = 0
var currentCooldown:float:
	get:
		return _currentCooldown
	set(val):
		_currentCooldown = val
		_currentCooldown = maxf(val, 0)
		cooldownUI.value = _currentCooldown

var _abilityIsPlanned := false
var abilityIsPlanned:bool:
	get:
		return _abilityIsPlanned
	set(val):
		_abilityIsPlanned = val
		border_active.visible = _abilityIsPlanned

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
		planAbility()
	#if event.is_action("shoot"):
		#useAbility()
	if event.is_action("cancelAbility"):
			abilityIsPlanned = false
		
# Called every frame. 'delta' is the elapsed time since the previous frame.
func startCooldown():
	abilityIsPlanned = false
	currentCooldown = cooldownTime
	pass
func useAbility():
	if abilityIsPlanned:
		startCooldown()
	pass
func planAbility():
	if abilityIsPlanned || currentCooldown > 0:
		return
	abilityIsPlanned = true
	abilityPlanned.emit(id)
	pass
func _process(delta):
	currentCooldown -= delta
	pass
func cancelQueue():
	abilityIsPlanned = false
