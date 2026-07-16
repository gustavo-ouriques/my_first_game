extends Area2D

func _on_body_entered(body: Node2D) -> void:
	call_deferred("load_game_win")

func load_game_win():
	get_tree().change_scene_to_file("res://menu/vitoria.tscn")
	
