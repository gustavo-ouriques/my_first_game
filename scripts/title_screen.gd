extends Control
@onready var start_button: Button = $MarginContainer/HBoxContainer/VBoxContainer/Start_Button


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	start_button.grab_focus()

func _process(_delta: float) -> void:
	pass

func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://cenas/forest.tscn")

func _on_credits_button_pressed() -> void:
	pass # Replace with function body.

func _on_quit_button_pressed() -> void:
	get_tree().quit()
