class_name FightHistory
extends Object

var history_by_turn : Dictionary

class TurnHistory:
	var actions_by_actor: Dictionary
	var index : int

var _current_turn : TurnHistory

func add_action(actor : ActorBase, action : ActionBase) -> void:
	#TODO: support multiple actions
	_current_turn.actions_by_actor[actor.lore_name] = action
	
func finish_turn() -> TurnHistory:
	var last_turn_idx = _current_turn.index
	history_by_turn[_current_turn.index] = _current_turn
	_current_turn = TurnHistory.new()
	_current_turn.index = last_turn_idx + 1
	return history_by_turn[last_turn_idx]

func _init():
	_current_turn = TurnHistory.new()
	_current_turn.index = 0
