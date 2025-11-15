extends Control

@onready var selector = $Selector
@onready var masuk_button = $ButtonList/Masuk
@onready var daftar_button = $ButtonList/Daftar
@onready var pengaturan_button = $ButtonList/Pengaturan
@onready var petunjuk_button = $ButtonList/Petunjuk


func _ready():
	masuk_button.grab_focus()
	
	_on_masuk_button_focus_entered()

func _on_masuk_button_focus_entered():
	_move_selector_to(masuk_button)

func _on_daftar_button_focus_entered():
	_move_selector_to(daftar_button)

func _on_pengaturan_button_focus_entered():
	_move_selector_to(pengaturan_button)

func _on_petunjuk_button_focus_entered():
	_move_selector_to(petunjuk_button)

func _move_selector_to(button_node):
	var target_y = button_node.global_position.y
	
	var center_y = target_y + (button_node.size.y / 2)
	selector.global_position.y = center_y - (selector.size.y / 2)
	
