class_name ActionHolder
extends Object

var _actions : Array = []
var _amount_by_action_name : Dictionary

class ActionWithAmount:
	var action : ActionBase
	var amount : int = -1
	var finite : bool = false

func _init() -> void:
	pass

func get_actions() -> Array:
	return _actions

func get_actions_with_amount() -> Array:
	var actions_with_amount : Array = []
	for a in _actions:
		actions_with_amount.append(_amount_by_action_name[a.lore_name])
	return actions_with_amount

func add_action(action : ActionBase, amount : int = 1) -> void:
	if _amount_by_action_name.has(action.lore_name):
		_amount_by_action_name[action.lore_name].amount += amount
		return 
	var new_action = ActionWithAmount.new()
	new_action.action = action
	new_action.finite = action.has_tag("one_use")
	new_action.amount = amount
	action.init_holder(self)
	_actions.append(action)
	_amount_by_action_name[action.lore_name] = new_action
	
func remove_action(action_name : String) -> void:
	_amount_by_action_name[action_name].amount -= 1
	if _amount_by_action_name[action_name].amount <= 0:
		for action in _actions:
			if action.lore_name == action_name:
				_actions.erase(action)
		_amount_by_action_name.erase(action_name)
