extends Node

var items = []


func add_item(
	item_name:String,
	icon:Texture2D = null
):
	items.append({
		"name":item_name,
		"icon":icon
	})
	print("item is added", items)



func remove_item(
	item_name:String
):
	for i in range(items.size()):
		if items[i]["name"]== item_name:
			items.remove_at(i)
			return
	
func has_item(item_name:String)-> bool:
	for item in items:
		if item["name"]== item_name:
			return true
	return false
