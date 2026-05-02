class_name Shop

extends CanvasLayer

@export var item_name_label: Label
@export var item_price_label: Label
@export var item_in_window_count_label: Label
@export var item_in_pocket_count_label: Label
@export var previous_button: Button
@export var next_button: Button
@export var buy_button: Button

const price_prefix: String = "$"
const count_prefix: String = "x"
const no_item_index: int = -1

var _current_item_index: int = no_item_index

func _ready() -> void:
	item_name_label.text = ""
	item_price_label.text = ""
	item_in_window_count_label.text = ""
	item_in_pocket_count_label.text = ""
	var first_available_item_id: int = _find_next_available_item_id(no_item_index, 1)
	if first_available_item_id == no_item_index:
		previous_button.hide()
		next_button.hide()
		buy_button.hide()
		return
	_current_item_index = first_available_item_id
	_represent_current_item()

func _on_previous_button_pressed() -> void:
	var previous_id: int = _find_next_available_item_id(_current_item_index, -1)
	if previous_id != no_item_index:
		_current_item_index = previous_id
		_represent_current_item()

func _on_next_button_pressed() -> void:
	var next_id: int = _find_next_available_item_id(_current_item_index, 1)
	if next_id != no_item_index:
		_current_item_index = next_id
		_represent_current_item()

func _on_buy_button_pressed() -> void:
	var item: ShopItemInfo = ShopStateHolder.items[_current_item_index]
	ShopStateHolder.window[item.id] -= 1
	if not ShopStateHolder.pocket.has(item.id):
		ShopStateHolder.pocket[item.id] = 1
	else:
		ShopStateHolder.pocket[item.id] += 1
	_represent_current_item_counts()

func _on_exit_button_pressed() -> void:
	var next_phase: Phase = PhaseManager.try_next_phase()
	get_tree().change_scene_to_file(next_phase.scene_name)

func _find_next_available_item_id(from_id: int, direction: int) -> int:
	var items: Array = ShopStateHolder.items
	if from_id == 0 and direction == -1:
		return no_item_index
	if from_id == items.size() - 1 and direction == 1:
		return no_item_index
	from_id += direction
	var item: ShopItemInfo = items[from_id]
	var count: int = _get_count(item.id, ShopStateHolder.window)
	return from_id if count > 0 else _find_next_available_item_id(from_id, direction)

func _represent_current_item():
	var item: ShopItemInfo = ShopStateHolder.items[_current_item_index]
	item_name_label.text = item.item_name
	item_price_label.text = str(price_prefix, item.price)
	_represent_current_item_counts()

func _represent_current_item_counts():
	var item: ShopItemInfo = ShopStateHolder.items[_current_item_index]
	var window_count: int = _get_count(item.id, ShopStateHolder.window)
	item_in_window_count_label.text = str(count_prefix, window_count)
	var pocket_count: int = _get_count(item.id, ShopStateHolder.pocket)
	item_in_pocket_count_label.text = str(count_prefix, pocket_count)
	_update_buttons_appearance()

func _update_buttons_appearance():
	var item: ShopItemInfo = ShopStateHolder.items[_current_item_index]
	var has_previous: bool = \
		_find_next_available_item_id(_current_item_index, -1) != no_item_index
	var has_next: bool = \
		_find_next_available_item_id(_current_item_index, 1) != no_item_index
	if not has_previous and previous_button.visible:
		previous_button.hide()
	elif has_previous and not previous_button.visible:
		previous_button.show()
	if not has_next and next_button.visible:
		next_button.hide()
	elif has_next and not next_button.visible:
		next_button.show()
	if ShopStateHolder.window[item.id] == 0 and buy_button.visible:
		buy_button.hide()
	elif ShopStateHolder.window[item.id] > 0 and not buy_button.visible:
		buy_button.show()

func _get_count(id: String, source: Dictionary) -> int:
	return 0 if not source.has(id) else source[id]
