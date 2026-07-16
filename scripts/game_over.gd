extends Control
@onready var restart_button: Button = $VBoxContainer/restart_button

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	restart_button.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_restart_button_pressed() -> void:
	get_tree().change_scene_to_file(GameManager.last_scene_path)
	# get_tree().change_scene_to_file("res://cenas/forest.tscn")

func _on_quit_button_pressed() -> void:
	get_tree().quit()
