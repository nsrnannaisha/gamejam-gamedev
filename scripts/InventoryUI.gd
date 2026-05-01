extends CanvasLayer

@onready var panel = $InventoryPanel
@onready var text = $InventoryPanel/InventoryText

var is_open := false
var selected_index := 0

func _ready():
	panel.visible = false
	
	# update awal biar ga kosong
	update_inventory()
	
	# auto update kalau ada item baru
	Inventory.item_added.connect(update_inventory)

func _process(_delta):
	if Input.is_action_just_pressed("inventory"):
		is_open = !is_open
		panel.visible = is_open
		Inventory.is_open = is_open
		
		if is_open:
			selected_index = 0
			update_inventory()

	if is_open:
		if Input.is_action_just_pressed("inv_down"):
			selected_index += 1
			update_inventory()

		if Input.is_action_just_pressed("inv_up"):
			selected_index -= 1
			update_inventory()

		if Input.is_action_just_pressed("use_item"):
			use_item()

func update_inventory():
	if Inventory.items.size() == 0:
		text.text = "Inventory kosong"
		return

	selected_index = clamp(selected_index, 0, Inventory.items.size() - 1)

	var display = "Inventory:\n"
	
	for i in range(Inventory.items.size()):
		var item = Inventory.items[i]
		
		if i == selected_index:
			display += "> " + item + "\n"
		else:
			display += item + "\n"
	
	text.text = display

func use_item():
	if Inventory.items.size() == 0:
		return
	
	var item = Inventory.items[selected_index]
	
	Inventory.remove_item(item)
	selected_index = clamp(selected_index, 0, Inventory.items.size() - 1)
	update_inventory()
