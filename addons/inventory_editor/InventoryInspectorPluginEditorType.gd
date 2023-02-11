# EditorProperty as Type for InventoryEditor : MIT License
# @author Vladimir Petrenko
extends EditorProperty
class_name InventoryInspectorEditorType

const Dropdown = preload("res://addons/ui_extensions/dropdown/Dropdown.tscn")

var updating = false
var dropdown = Dropdown.instantiate()
var _data: InventoryData

func set_data(data: InventoryData) -> void:
	_data = data
	_data.type_added.connect(_update_dropdown)
	_data.type_removed.connect(_update_dropdown)
	
func _init():
	add_child(dropdown)
	add_focusable(dropdown)
	dropdown.selection_changed.connect(_on_selection_changed)

func _update_dropdown() -> void:
	dropdown.clear()
	for type in _data.types:
		var type_icon = null
		if type.icon != null and not type.icon.is_empty():
			type_icon = load(type.icon)
		var item_d = DropdownItem.new(type.uuid, type.name, type.name, type_icon)
		dropdown.add_item(item_d)

func _on_selection_changed(item: DropdownItem):
	if (updating):
		return
	emit_changed(get_edited_property(), item.value)

func _update_property():
	var new_value = get_edited_object()[get_edited_property()]
	updating = true
	dropdown.set_selected_by_value(new_value)
	updating = false

