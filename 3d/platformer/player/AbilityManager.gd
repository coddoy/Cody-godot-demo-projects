extends HBoxContainer

var abilities:Dictionary={}

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is AbilityButtonUI:
			child.initialize()
			abilities[child.id.to_lower()] = child
			child.abilityQueued.connect(onChildAbilityQueued)
	pass # Replace with function body.

func onChildAbilityQueued(initiatorId:String):
	assert(abilities.has(initiatorId),"onChildAbilityQueued triggered for "+initiatorId+" which isn't in dict")
	for key in abilities:
		if key != initiatorId:
			var child: AbilityButtonUI = abilities[key]
			child.cancelQueue()
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
