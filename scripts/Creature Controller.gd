extends Controllable

var level_node:Node3D
var creature_root:Node3D
@onready var abilities_hud = $Hud/Abilities/HFlowContainer

# initialise nav mesh for controllable class
func set_up(level:Node3D, world:World3D):
	# adjust position of graphics to account for floating navmesh
	global_position.y = 0.5
	
	level_node = level
	creature_root = get_parent()
	_initialise(world, creature_root)
	
	self.tree_exited.connect(_on_tree_exiting)
	
	var creature_name:String = (creature_root.name).split(" ")[1]
	
	# set creature name
	get_node("Hud/Abilities/name").text = creature_name
	
	# abilities
	var first_ability:TextureButton = abilities_hud.get_node("FirstAbility")
	var second_ability:TextureButton = abilities_hud.get_node("SecondAbility")
	var third_ability:TextureButton = abilities_hud.get_node("ThirdAbility")
	
	first_ability.set_up(CreatureAbilityManager.get_ability_sprite(creature_name, 1), CreatureAbilityManager.get_ability_cooldown(creature_name, 1))
	second_ability.set_up(CreatureAbilityManager.get_ability_sprite(creature_name, 2), CreatureAbilityManager.get_ability_cooldown(creature_name, 2))
	third_ability.set_up(CreatureAbilityManager.get_ability_sprite(creature_name, 3), CreatureAbilityManager.get_ability_cooldown(creature_name, 3))


func perform_action(i:int):
	abilities_hud.get_child(i).pressed()


func _on_tree_exiting():
	finish_point.queue_free.call_deferred()
	creature_root.queue_free.call_deferred()
