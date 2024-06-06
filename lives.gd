extends MeshInstance3D

var rotateSpeed: int = 2

func _process(delta):
	rotate_y(delta * rotateSpeed)

func _on_child_entered_tree(node):
	if node.name == "Player":
		queue_free()
		node.give_life()
		$StatusBar/LifeNoise.play()
