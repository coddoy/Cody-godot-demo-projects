extends HBoxContainer
class_name AbilityManager

var abilities:Dictionary={}

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in get_children():
		if child is AbilityButtonUI:
			var ability:AbilityButtonUI =child
			ability.initialize()
			abilities[ability.id.to_lower()] = ability
			ability.abilityPlanned.connect(onChildAbilityQueued)
	pass # Replace with function body.

func onChildAbilityQueued(initiatorId:String):
	assert(abilities.has(initiatorId),"onChildAbilityQueued triggered for "+initiatorId+" which isn't in dict")
	for key in abilities:
		if key != initiatorId:
			var child: AbilityButtonUI = abilities[key]
			child.cancelQueue()
	pass

func getBullet() -> Resource:
	for key in abilities:
		var child: AbilityButtonUI = abilities[key]
		if child.abilityIsPlanned:
			child.useAbility()
			var bullet = child.bullet
			if bullet:
				return bullet
	return null
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
