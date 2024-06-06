extends Node3D

@onready var loadedEnemy = preload("res://Enemy.tscn")

func _on_enemy_timer_timeout():
	var enemy = loadedEnemy.instantiate()
	enemy.set_position(Vector3())
	
	var rng = RandomNumberGenerator.new()
	var rnd = rng.randi_range(-17, 30)
	var rnd2 = rng.randi_range(-30, 20)
	
	enemy.transform.origin = Vector3(rnd, 0.25, rnd2)
	add_child(enemy)
