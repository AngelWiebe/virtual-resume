extends CanvasLayer

var pauseScreen;
@onready var music = get_node("../BackgroundNoise")
@onready var button = get_node("Menu/Reset")

func _ready():
	music.stop()
	get_tree().paused = true
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	pauseScreen = get_node('.')
	pauseScreen.show()
	$Menu/MenuMusic.play()

func _input(event):
	if event.is_action_pressed("pause"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		get_tree().paused = true
		pauseScreen.show()
		$Menu/MenuMusic.play()

func _on_proceed_pressed():
	get_tree().paused = false
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	pauseScreen.hide()
	$Menu/MenuMusic.stop()
	music.play()

func _on_restart_pressed():
	button.disabled = true
	button.text = "Loading..."
	get_tree().reload_current_scene()
