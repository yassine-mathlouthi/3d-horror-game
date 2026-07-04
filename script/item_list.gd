extends CanvasLayer

@onready var item_list: VBoxContainer = $Panel/ItemList


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
	for child in item_list.get_children():
		child.queue_free()

	for item in Inventory.items:
		var row := HBoxContainer.new()

		var icon := TextureRect.new()
		icon.texture = item["icon"]
		icon.custom_minimum_size = Vector2(24, 24)
		icon.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
		icon.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED

		var label := Label.new()
		label.text = item["name"]

		row.add_child(icon)
		row.add_child(label)
		item_list.add_child(row)
