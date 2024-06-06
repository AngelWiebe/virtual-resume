extends CharacterBody3D

var curHP: int = 3
var maxHP: int = 3
var damage: int = 1
var attackDist: float = 0.8
var attackRate: float = 1.5
var moveSpeed: float = 1

@onready var timer = get_node("Timer")
@onready var player = get_node("/root/MainScene/Player")

func _ready():
	timer.wait_time = attackRate
	timer.start()

func _physics_process(_delta):
	var dist = position.distance_to(player.position)
	var direction = (player.position - position).normalized()

	if dist < 5:
		velocity = position.direction_to(player.position) * moveSpeed

		var angle = atan2(direction.x,direction.z)
		rotation.y = angle
		move_and_slide()

func _on_timer_timeout():
	if position.distance_to(player.position) <= attackDist:
		player.take_damage(damage)

func take_damage(damageToTake):
	curHP -= damageToTake
	
	if curHP <= 0:
		$Death.play()
		die()

func die():
	queue_free()
