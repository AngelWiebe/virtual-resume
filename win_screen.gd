extends CanvasLayer

@onready var winScreen = get_node(".")
@onready var button = get_node('Menu/Proceed')

func _ready():
	winScreen.hide()

func _on_proceed_pressed():
	button.disabled = true
	button.text = "Loading..."
	get_tree().reload_current_scene()
