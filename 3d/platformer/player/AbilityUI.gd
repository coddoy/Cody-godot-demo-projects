extends PanelContainer

@onready var cooldownUI:ProgressBar = $Cooldown
@export var hotKey := "ability 1"
@export var cooldownTime:float = 4
var currentCooldown:float = 0
# Called when the node enters the scene tree for the first time.
func _ready():
	cooldownUI.max_value = cooldownTime
	pass # Replace with function body.

func _input(event):
	if currentCooldown != 0:
		return
	if event.is_action(hotKey):
		currentCooldown = cooldownTime
		cooldownUI.value = cooldownTime
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if currentCooldown == 0:
		return
	currentCooldown = maxf(currentCooldown - delta, 0)
	cooldownUI.value = currentCooldown
	pass
