extends CanvasLayer

const SLOT_COUNT := 12
const SLOT_SIZE := Vector2(112, 92)

@onready var grid: GridContainer = $Root/InventoryPanel/Margin/VBox/Grid


func _ready() -> void:
	hide()
	Inventory.changed.connect(update_inventory)
	update_inventory()


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("Inventory"):
		visible = !visible
		if visible:
			update_inventory()


func update_inventory() -> void:
	for child in grid.get_children():
		child.queue_free()

	var visible_slots: int = max(SLOT_COUNT, Inventory.items.size())
	for index in range(visible_slots):
		if index < Inventory.items.size():
			grid.add_child(_create_item_slot(Inventory.items[index]))
		else:
			grid.add_child(_create_empty_slot())


func _create_item_slot(item: Dictionary) -> PanelContainer:
	var slot := _create_slot_panel(Color(0.11, 0.09, 0.065, 0.94), Color(0.74, 0.53, 0.25, 0.95))

	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 8)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_right", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	slot.add_child(margin)

	var content := VBoxContainer.new()
	content.alignment = BoxContainer.ALIGNMENT_CENTER
	content.add_theme_constant_override("separation", 6)
	margin.add_child(content)

	var icon := TextureRect.new()
	icon.texture = item.get("icon")
	icon.custom_minimum_size = Vector2(46, 46)
	icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	content.add_child(icon)

	var label := Label.new()
	label.text = str(item.get("name", "Item")).capitalize()
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	label.modulate = Color(0.92, 0.84, 0.68, 1)
	content.add_child(label)

	return slot


func _create_empty_slot() -> PanelContainer:
	return _create_slot_panel(Color(0.055, 0.052, 0.047, 0.72), Color(0.22, 0.19, 0.15, 0.75))


func _create_slot_panel(background: Color, border: Color) -> PanelContainer:
	var slot := PanelContainer.new()
	slot.custom_minimum_size = SLOT_SIZE
	slot.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	slot.size_flags_vertical = Control.SIZE_EXPAND_FILL
	slot.add_theme_stylebox_override("panel", _create_slot_style(background, border))
	return slot


func _create_slot_style(background: Color, border: Color) -> StyleBoxFlat:
	var style := StyleBoxFlat.new()
	style.bg_color = background
	style.border_color = border
	style.set_border_width_all(1)
	style.set_corner_radius_all(8)
	style.shadow_color = Color(0, 0, 0, 0.35)
	style.shadow_size = 6
	return style
