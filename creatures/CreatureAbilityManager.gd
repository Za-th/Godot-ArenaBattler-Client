extends Node

var creature_map:Dictionary = {
	"Rat": {
		1: {"Sprite": "res://sprites/creatures/lightning.png",
			"Cooldown": 3.0},
		2: {"Sprite": "res://sprites/creatures/speed_debuff.png",
			"Cooldown": 5.0},
		3: {"Sprite": "res://sprites/creatures/stun.png",
			"Cooldown": 2.0}
	},
	
	"Bird": {
		1: {"Sprite": "res://sprites/creatures/tornado.png",
			"Cooldown": 3.0},
		2: {"Sprite": "res://sprites/creatures/push.png",
			"Cooldown": 5.0},
		3: {"Sprite": "res://sprites/creatures/shield.png",
			"Cooldown": 2.0}
	},
	
	"Cat": {
		1: {"Sprite": "res://sprites/creatures/bleed.png",
			"Cooldown": 3.0},
		2: {"Sprite": "res://sprites/creatures/multi_attack.png",
			"Cooldown": 5.0},
		3: {"Sprite": "res://sprites/creatures/hiss.png",
			"Cooldown": 2.0}
	},
	
	"Dog": {
		1: {"Sprite": "res://sprites/creatures/jump.png",
			"Cooldown": 3.0},
		2: {"Sprite": "res://sprites/creatures/tail_whip.png",
			"Cooldown": 5.0},
		3: {"Sprite": "res://sprites/creatures/charge.png",
			"Cooldown": 2.0}
	}
}

func get_ability_sprite(creature_name:String, ability:int) -> String:
	if !creature_map.has(creature_name):
		return "res://sprites/error.png"
	return creature_map[creature_name][ability]["Sprite"]

func get_ability_cooldown(creature_name:String, ability:int) -> float:
	if !creature_map.has(creature_name):
		return 10.0
	return creature_map[creature_name][ability]["Cooldown"]
