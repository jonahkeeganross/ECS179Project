extends Node

# Shop item prices
const HEALTH_POTION_PRICE: int = 10
const DAMAGE_UPGRADE_PRICE: int = 20
const STAMINA_UPGRADE_PRICE: int = 15

var shop_ui_scene = preload("res://Scenes/ShopUI.tscn")
var shop_ui_instance = null

#func _ready():
	#print("ShopManager: Ready")

func get_or_create_shop_ui():
	if shop_ui_instance == null:
		shop_ui_instance = shop_ui_scene.instantiate()
		get_tree().root.add_child(shop_ui_instance)
		#print("ShopManager: Created new ShopUI instance")
	return shop_ui_instance

func open_shop(player):
	var shop = get_or_create_shop_ui()
	if shop and shop.has_method("open_shop"):
		shop.open_shop(player)
	else:
		print("ShopManager: ERROR - shop instance invalid")
