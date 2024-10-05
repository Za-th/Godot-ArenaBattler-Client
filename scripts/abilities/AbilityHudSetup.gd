extends Control

# initialise nav mesh for controllable class
func set_up(_name:String):
	
	# set creature name
	get_node("name").text = _name
	
	# abilities hud
	var first_ability:TextureButton = get_node("HFlowContainer/FirstAbility")
	var second_ability:TextureButton = get_node("HFlowContainer/SecondAbility")
	var third_ability:TextureButton = get_node("HFlowContainer/ThirdAbility")
	
	first_ability.set_up(AbilitySpriteHandler.get_ability_sprite(_name, 1), AbilitySpriteHandler.get_ability_cooldown(_name, 1))
	second_ability.set_up(AbilitySpriteHandler.get_ability_sprite(_name, 2), AbilitySpriteHandler.get_ability_cooldown(_name, 2))
	third_ability.set_up(AbilitySpriteHandler.get_ability_sprite(_name, 3), AbilitySpriteHandler.get_ability_cooldown(_name, 3))
