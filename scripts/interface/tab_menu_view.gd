extends Control

@onready var inventory_view: InventoryView = %InventoryView

var is_opened: bool = false

func _ready() -> void:
	close()

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("open_tab_menu"):
		if is_opened:
			close()
		else:
			open()

func open() -> void:
	PlayerModule.player.freeze()
	is_opened = true
	visible = true

func close() -> void:
	PlayerModule.player.unfreeze()
	is_opened = false
	visible = false