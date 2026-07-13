extends Area2D

@onready var animated: AnimatedSprite2D = $AnimatedSprite2D


var speed = 60
var direction = 1

func _process(delta: float) -> void:
	position.x += speed * delta * direction

func set_direction(direction): #esse (direction) vem de fora.
	self.direction = direction
	#muda a direcao do osso de acordo com o esqueleto. video #31 minuto: 25:00
	animated.flip_h = direction < 0
