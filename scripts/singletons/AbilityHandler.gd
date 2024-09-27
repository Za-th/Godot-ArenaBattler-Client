extends Node

@rpc("authority", "call_remote")
func used_ability(user:String, ability:String, selected_enemy:String):
	used_ability.rpc_id(1, user, ability, selected_enemy)
