extends StaticBody3D

const KEY_ICON := preload("res://assets/Icons/key.png")


func interact() -> void:
	Inventory.add_item("key", KEY_ICON)
	queue_free()


func intreact() -> void:
	interact()
