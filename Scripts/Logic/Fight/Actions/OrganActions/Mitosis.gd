class_name ActionMitosisL
extends ActionBase

var action_name = "mitosis"

var formated_result : String = "{initiator} создает ещё одно щупальце."

func _init() -> void:
	super(action_name)

func _parse_stats() -> void:
	pass

func take_action(initiator: ActorBase, targets : Array) -> ActionResult:
	var tentacle = initiator as OrganTentacle
	tentacle.organ_summoner.summon_by_name("small_tentacle")
	super.take_action(initiator, targets)
	return ActionResult.new(formated_result, {"initiator" : initiator.lore_name})
