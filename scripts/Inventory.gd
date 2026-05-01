extends Node

var items := []
var is_open := false
var death_count := 0
var has_pistol := false

signal item_added(item_name)

func add_item(item_name):
	items.append(item_name)
	emit_signal("item_added", item_name)

func remove_item(item_name):
	items.erase(item_name)
