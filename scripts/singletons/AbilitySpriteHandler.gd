extends Node

var sprite_map:Dictionary = {
	"Player": {
		1: {"Sprite": "res://sprites/heal.png",
			"Cooldown": 8.0
			},
		2: {"Sprite": "res://sprites/damage.png",
			"Cooldown": 10.0
			},
		3: {"Sprite": "res://sprites/attack.png",
			"Cooldown": 1.0
			}
	},
	
	"Rat": {
		1: {"Sprite": "res://sprites/creatures/lightning.png",
			"Cooldown": 5.0
			},
		2: {"Sprite": "res://sprites/creatures/speed_debuff.png",
			"Cooldown": 8.0
			},
		3: {"Sprite": "res://sprites/creatures/stun.png",
			"Cooldown": 5.0
			}
	},
	
	"Bird": {
		1: {"Sprite": "res://sprites/creatures/tornado.png",
			"Cooldown": 5.0
			},
		2: {"Sprite": "res://sprites/creatures/push.png",
			"Cooldown": 5.0
			},
		3: {"Sprite": "res://sprites/creatures/shield.png",
			"Cooldown": 6.0
			}
	},
	
	"Cat": {
		1: {"Sprite": "res://sprites/creatures/bleed.png",
			"Cooldown": 7.0
			},
		2: {"Sprite": "res://sprites/creatures/multi_attack.png",
			"Cooldown": 5.0
			},
		3: {"Sprite": "res://sprites/creatures/hiss.png",
			"Cooldown": 15.0
			}
	},
	
	"Dog": {
		1: {"Sprite": "res://sprites/creatures/jump.png",
			"Cooldown": 8.0
			},
		2: {"Sprite": "res://sprites/creatures/tail_whip.png",
			"Cooldown": 5.0
			},
		3: {"Sprite": "res://sprites/creatures/charge.png",
			"Cooldown": 12.0
			}
	}
}

func get_ability_sprite(_name:String, ability:int) -> String:
	if !sprite_map.has(_name):
		return "res://sprites/error.png"
	return sprite_map[_name][ability]["Sprite"]

func get_ability_cooldown(_name:String, ability:int) -> float:
	if !sprite_map.has(_name):
		return 10.0
	return sprite_map[_name][ability]["Cooldown"]
