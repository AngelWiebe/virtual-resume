extends Control

@onready var healthBar = get_node("./StatusBar/HealthBar")
@onready var skills = get_node("./StatusBar/Skills")
@onready var winScreen = get_node("./WinScreen")
	
func update_health_bar(curHp, maxHp):
	healthBar.value = (100/maxHp) * curHp
	
func update_skills_label(count, maxSkills):
	skills.text = str(count) + " / " + str(maxSkills)

func show_win_screen():
	$WinScreen/Menu/MenuMusic.play()
	winScreen.show()

func stop_music():
	$BackgroundNoise.stop()
	
func start_music():
	$BackgroundNoise.play()

func play_death():
	$PlayerDeath.play()
