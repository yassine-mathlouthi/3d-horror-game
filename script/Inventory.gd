extends Node

signal changed

var items: Array[Dictionary] = []


func add_item(
	item_name:String,
	icon:Texture2D = null
):
	if has_item(item_name):
		return

	items.append({
		"name":item_name,
		"icon":icon
	})
	changed.emit()



func remove_item(
	item_name:String
):
	for i in range(items.size()):
		if items[i]["name"]== item_name:
			items.remove_at(i)
			changed.emit()
			return
	
func has_item(item_name:String)-> bool:
	for item in items:
		if item["name"]== item_name:
			return true
	return false
