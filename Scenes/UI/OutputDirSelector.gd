extends HBoxContainer

onready var FileDialog := $FileDialog
onready var ChooseDirLineEdit := $ChooseDirLineEdit
onready var ChooseDirButton := $ChooseDirButton
onready var HelpDialog := $HelpDialog


func load_from_config():
	ChooseDirLineEdit.text = Config.csv_dir


func disable_editing():
	ChooseDirButton.disabled = true
	

func enable_editing():
	ChooseDirButton.disabled = false


func _on_FileDialog_dir_selected(dir):
	dir += "/"
	ChooseDirLineEdit.text = dir
	Config.csv_dir = dir
	

func _on_ChooseDirButton_pressed():
	FileDialog.popup_centered(Config.DIALOG_POPUP_SIZE_L)


func _on_HelpButton_pressed():
	HelpDialog.popup_centered(Config.DIALOG_POPUP_SIZE_S)
