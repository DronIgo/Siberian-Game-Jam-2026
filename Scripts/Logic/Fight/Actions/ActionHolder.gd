class_name ActionHolder
extends Object

var _actions : Array = []
var _item_actions : Array = []
var _amount_by_action_name : Dictionary

class ActionWithAmount:
	var action : ActionBase
	var amount : int

func _init() -> void:
	pass

func get_actions() -> Array:
	return _actions
	
func get_item_actions() -> Array:
	var actions_with_amount : Array = []
	for item in _item_actions:
		var a : ActionWithAmount = ActionWithAmount.new()
		a.action = item
		a.amount = _amount_by_action_name[item.lore_name]
		actions_with_amount.append(a)
	return actions_with_amount

func add_action(action : ActionBase) -> void:
	for a in _actions:
		if a.lore_name == action.lore_name:
			return
	_actions.append(action)
	
func add_item_action(action : ActionBase, amount : int) -> void:
	if _amount_by_action_name.has(action.lore_name):
		_amount_by_action_name[action.lore_name] += amount
	else:
		_item_actions.append(action)
		_amount_by_action_name[action.lore_name] = amount

func remove_action(action_name : String) -> void:
	_amount_by_action_name[action_name] -= 1
	if _amount_by_action_name[action_name] <= 0:
		for action in _item_actions:
			if action.lore_name == action_name:
				_item_actions.erase(action)
		_amount_by_action_name.erase(action_name)
