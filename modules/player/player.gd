extends Node
class_name Player

@onready var pawn: PlayerPawn = %Pawn
@onready var inventory: Inventory = %Inventory

#region Freeze

func set_frozen(frozen: bool) -> void:
	if frozen:
		freeze()
	else:
		unfreeze()
	
func freeze() -> void:
	pawn.process_mode = Node.PROCESS_MODE_DISABLED

func unfreeze() -> void:
	pawn.process_mode = Node.PROCESS_MODE_INHERIT

#endregion

# TODO: FIX calling freeze() on player freezes its position (e.g. mid-jump) but the game keeps playing