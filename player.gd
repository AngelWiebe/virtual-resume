extends CharacterBody3D

const moveSpeed: float = 5.0
const jumpForce: float = 5
const gravity: float = 15

var curHP: int = 5
var maxHP: int = 5
var damage: int = 1
var skills: int = 0
var maxSkills: int = 14

var attackRate: float = 0.3
var lastAttackTime: int = 0

@onready var camera = get_node("CameraOrbit");
@onready var attackCast = get_node("AttackRayCast")
@onready var ui = get_node("CanvasLayer/UI")

func give_life():
	curHP += 1
	$LifeNoise.play()
	ui.update_health_bar(curHP, maxHP)

func give_skill():
	skills += 1
	if skills == maxSkills:
		win()
	else:
		$SkillNoise.play()
		ui.update_skills_label(skills, maxSkills)

func win():
	$Win.play()
	ui.show_win_screen()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
func _ready(): 
	ui.update_health_bar(curHP, maxHP)
	ui.update_skills_label(skills, maxSkills)

func _process(_delta):
	if Input.is_action_just_pressed("attack"):
		$Swing.play()
		try_attack()

func _physics_process(delta):
	if not is_on_floor():
		velocity.y -= gravity * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = jumpForce
		$Jump.play()

	for index in range(get_slide_collision_count()):

		var collision = get_slide_collision(index)

		if !collision || collision.get_collider() == null:
			continue

		var collider = collision.get_collider()

		if collider.is_in_group("skills"):
			collider.get_parent().queue_free()
			await get_tree().create_timer(.05).timeout 
			give_skill()

		elif collider.is_in_group("lives"):
			collider.get_parent().queue_free()
			await get_tree().create_timer(.05).timeout
			give_life()

	var input_dir = Input.get_vector("move_left", "move_right", "move_forward", "move_backwards")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * moveSpeed
		velocity.z = direction.z * moveSpeed
	else:
		velocity.x = move_toward(velocity.x, 0, moveSpeed)
		velocity.z = move_toward(velocity.z, 0, moveSpeed)

	move_and_slide()

func take_damage(damageToTake):
	curHP -= damageToTake
	ui.update_health_bar(curHP, maxHP)

	if curHP <= 0:
		ui.stop_music()
		ui.play_death()
		die()
	else:
		$Hit.play()

func die():
	get_tree().reload_current_scene()

func try_attack():
	if Time.get_ticks_msec() - lastAttackTime < attackRate * 1000:
		return;

	lastAttackTime = Time.get_ticks_msec()
	$WeaponHolder/SwordAnimation.stop()
	$WeaponHolder/SwordAnimation.play("attack")

	if attackCast.is_colliding():
		if attackCast.get_collider().has_method("take_damage"):
			attackCast.get_collider().take_damage(damage)
