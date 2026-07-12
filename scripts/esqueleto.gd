extends CharacterBody2D

enum EsqueletoState{
	walk,
	dead
}

@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
@onready var hitbox: Area2D = $Hitbox
@onready var wall_detector: RayCast2D = $WallDetector
@onready var ground_detector: RayCast2D = $GroundDetector



const SPEED = 80.0
const JUMP_VELOCITY = -300.0

var status: EsqueletoState

var direction = 1

func _ready() -> void:
	go_to_walk_state()

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	match status:
		EsqueletoState.walk:
			walk_state(delta)
		EsqueletoState.dead:
			dead_state(delta)
	
	move_and_slide()

func go_to_walk_state():
	status = EsqueletoState.walk
	animated.play("walk")
	
func go_to_dead_state():
	status = EsqueletoState.dead
	animated.play("dead")
	hitbox.process_mode = Node.PROCESS_MODE_DISABLED
	velocity = Vector2.ZERO
	
	
func walk_state(_delta):
	velocity.x = SPEED * direction
	
	if wall_detector.is_colliding():
		scale.x *= -1
		direction *= -1
		
	if not ground_detector.is_colliding():
		scale.x *= -1
		direction *= -1
	
func dead_state(_delta):
	pass
	
func take_damage():
	go_to_dead_state()
