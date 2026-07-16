extends Area2D

@onready var animated: AnimatedSprite2D = $AnimatedSprite2D


var speed = 80
var direction = 1

func _process(delta: float) -> void:
	position.x += speed * delta * direction

func set_direction(Esqueleto_direction): #esse (direction) vem de fora.
	direction = Esqueleto_direction
	#muda a direcao do osso de acordo com o esqueleto.
	animated.flip_h = direction < 0

func _on_self_destruct_timer_timeout() -> void:
	queue_free()

func _on_area_entered(_area: Area2D) -> void:
	queue_free()

func _on_body_entered(_body: Node2D) -> void:
	queue_free()
