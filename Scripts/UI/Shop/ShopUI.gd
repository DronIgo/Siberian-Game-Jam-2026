class_name ShopUI
extends CanvasLayer

const SHOP_ITEM = preload("uid://3sr04u60o6t4")

@export var display_item_scene: PackedScene
@export var item_list : ItemListUI
@export var cash_label: Label

var items_map: Dictionary = {}

func _ready() -> void:
	ShopEventBus.item_bought.connect(_on_item_bought)
	_update_cash_label()
	_display_items()

func _on_item_bought(item : ShopItemUI):
	_update_cash_label()
	_display_items()

func _on_exit_button_pressed() -> void:
	var next_phase: Phase = PhaseManager.try_next_phase()
	get_tree().change_scene_to_file(next_phase.scene_name)

func _display_items():
	var items: Array = ItemStateHolder.items
	var itemUIs = []
	for item: ShopItemInfo in items:
		if not ItemStateHolder.shop_window.has(item.id):
			continue
		var count = ItemStateHolder.shop_window[item.id]
		if count == 0:
			continue
		
		var new_item = SHOP_ITEM.instantiate() as ShopItemUI
		new_item.init_item(\
			item.id, 
			item.item_name, 
			item.description, 
			item.price,
			count
		)
		itemUIs.append(new_item)
	item_list.display_item_list(itemUIs)

func _update_cash_label():
	cash_label.text = str(ItemStateHolder.player_cash)
