extends Area2D

@export var next_level = ""
@export var game_win = ""


func _on_body_entered(_body: Node2D) -> void:
	call_deferred("load_next_scene")
	
func load_next_scene():
	get_tree().change_scene_to_file("res://cenas/" + next_level + ".tscn")

func load_game_win():
	get_tree().change_scene_to_file("res://menu/vitoria.tscn")
