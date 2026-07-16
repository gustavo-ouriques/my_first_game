@tool
extends CanvasLayer

@export var phase_text: String = "":
	set(value):
		phase_text = value
		if counter:
			counter.text = value

@onready var counter: Label = $control/container/VBoxContainer/counter

func _ready() -> void:
	counter.text = phase_text
