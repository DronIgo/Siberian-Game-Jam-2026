class_name Shop

extends CanvasLayer

@export var display_x_px_delta: int = 550
@export var display_y_px_delta: int = 55
@export var display_x_max: int = 2
@export var display_y_max: int = 5
@export var display_item_scene: PackedScene
@export var items_base: Control
@export var description_label: Label
@export var cash_label: Label

var items_map: Dictionary = {}

func _ready() -> void:
	ShopEventBus.item_selected.connect(_on_item_selected)
	ShopEventBus.item_unselected.connect(_on_item_unselected)
	ShopEventBus.item_bought.connect(_on_item_bought)
	_update_cash_label()
	_display_items()

func _on_item_selected(id: String):
	description_label.show()
	description_label.text = items_map[id].description

func _on_item_unselected(id: String):
	description_label.hide()

func _on_item_bought(id: String):
	description_label.hide()
	_update_cash_label()
	_display_items()

func _on_exit_button_pressed() -> void:
	var next_phase: Phase = PhaseManager.try_next_phase()
	get_tree().change_scene_to_file(next_phase.scene_name)

func _display_items():
	for existing_item in items_base.get_children():
		existing_item.queue_free()
	var items: Array = ItemStateHolder.items
	var x: int = 0
	var y: int = 0
	for item: ShopItemInfo in items:
		if not ItemStateHolder.shop_window.has(item.id):
			continue
		var count = ItemStateHolder.shop_window[item.id]
		if count == 0:
			continue
		items_map[item.id] = item
		while count > 0:
			var display_item: ShopItem = display_item_scene.instantiate()
			display_item.init(item.id, item.item_name, item.price)
			display_item.position.x = display_x_px_delta * x
			display_item.position.y = display_y_px_delta * y
			items_base.add_child(display_item)
			y += 1
			if y > display_y_max:
				y = 0
				x += 1
			count -= 1

func _update_cash_label():
	cash_label.text = str(ItemStateHolder.player_cash)
