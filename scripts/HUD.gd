extends CanvasLayer

@onready var hud_control = $HUDControl
@onready var inventory_panel = $HUDControl/InventoryPanel
@onready var inventory_text = $HUDControl/InventoryPanel/InventoryText
@onready var info_panel = $HUDControl/InfoPanel
@onready var info_title = $HUDControl/InfoPanel/Title
@onready var info_level_text = $HUDControl/InfoPanel/LevelText
@onready var info_button = $HUDControl/InfoButton
@onready var controls_text = $HUDControl/InfoPanel/GuideContainer/ControlsText

var selected_index := 0

func _ready():
	inventory_panel.visible = false
	
	Inventory.item_added.connect(update_inventory)
	update_inventory()
	
	setup_level_info()
	
	show_info_panel()

func setup_level_info():
	var scene_name = get_tree().current_scene.name
	var file_path = get_tree().current_scene.scene_file_path.to_lower()
	
	controls_text.text = (
		"[color=#a0efff]Arrow Keys[/color]\t: Walk\n" +
		"[color=#a0efff]Shift[/color]\t\t\t: Run\n" +
		"[color=#a0efff]I[/color]\t\t\t\t\t: Open Inventory\n" +
		"[color=#a0efff]CTRL[/color]\t\t\t\t: Shoot"
	)
	
	if "forest" in file_path or "forest" in scene_name.to_lower():
		info_title.text = "FOREST: PREPARATION"
		info_level_text.text = (
			"To prepare for what you will encounter in the next arena, collect a pistol."
		)
	else:
		info_title.text = "LEVEL 1"
		info_level_text.text = (
			"Be careful of robbers. You can shoot them if you collected pistol earlier. Pay attention to the health bar or you will lose."
		)

func show_info_panel():
	info_panel.visible = true
	info_button.visible = false
	inventory_panel.visible = false
	Inventory.is_open = true 
	
func hide_info_panel():
	info_panel.visible = false
	info_button.visible = true
	Inventory.is_open = false 
func _process(_delta):
	if info_panel.visible:
		if Input.is_action_just_pressed("ui_accept"):
			hide_info_panel()
		return
		
	if Input.is_action_just_pressed("inventory"):
		var is_open = !inventory_panel.visible
		inventory_panel.visible = is_open
		Inventory.is_open = is_open
		if is_open:
			selected_index = 0
			update_inventory()

	if inventory_panel.visible:
		if Input.is_action_just_pressed("inv_down"):
			selected_index += 1
			update_inventory()
		elif Input.is_action_just_pressed("inv_up"):
			selected_index -= 1
			update_inventory()
		elif Input.is_action_just_pressed("use_item"):
			use_item()

func update_inventory():
	if Inventory.items.size() == 0:
		inventory_text.text = "Inventory Kosong"
		return
		
	selected_index = clamp(selected_index, 0, Inventory.items.size() - 1)
	var display = "INVENTORY:\n"
	for i in range(Inventory.items.size()):
		var item = Inventory.items[i]
		if i == selected_index:
			display += "> [ " + item + " ] <\n"
		else:
			display += "  " + item + "\n"
	inventory_text.text = display

func use_item():
	if Inventory.items.size() == 0:
		return
		
	var item = Inventory.items[selected_index]
	Inventory.remove_item(item)
	selected_index = clamp(selected_index, 0, Inventory.items.size() - 1)
	update_inventory()

func _on_close_button_pressed():
	hide_info_panel()

func _on_info_button_pressed():
	show_info_panel()
