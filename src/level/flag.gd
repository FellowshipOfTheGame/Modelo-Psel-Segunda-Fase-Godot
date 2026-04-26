extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		# call_deferred chama uma função assim que todos processamentos do frame atual
		# tiverem terminados. É importante fazer isso para evitar que um objeto seja deletado
		# enquanto ainda está sendo processado
		get_tree().call_deferred("change_scene_to_file", "res://src/main-menu.tscn")
