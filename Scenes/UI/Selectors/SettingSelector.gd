extends HBoxContainer

onready var DropDown := $DropDown
onready var HelpDialog := $HelpDialog

func _ready():
	DropDown.add_item("Meadow")
	DropDown.add_item("Desert")


func load_from_config():
	DropDown.selected = Config.env_setting
	

func disable_editing():
	DropDown.disabled = true
	
	
func enable_editing():
	DropDown.disabled = false


func _on_DropDown_item_selected(id):
	Config.env_setting = id
	get_tree().call_group("config", "env_setting_changed")


func _on_HelpButton_pressed():
	HelpDialog.popup_centered(Config.DIALOG_POPUP_SIZE_S)
