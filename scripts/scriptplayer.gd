extends CharacterBody2D

enum PlayerState{
	idle,
	walk,
	jump,
	duck
}

@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D

const SPEED = 80.0
const JUMP_VELOCITY = -300.0

var direction = 0
var status: PlayerState

func _ready() -> void:
	go_to_idle_state()
	
func _physics_process(delta: float) -> void:
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match status:
		PlayerState.idle:
			idle_state()
		PlayerState.walk:
			walk_state()
		PlayerState.jump:
			jump_state()
		PlayerState.duck:
			duck_state()
		
	move_and_slide()
	
func go_to_idle_state():
	status = PlayerState.idle
	animated.play("idle")
	
func go_to_walk_state():
	status = PlayerState.walk
	animated.play("walk")
	
func go_to_jump_state():
	status = PlayerState.jump
	animated.play("jump")
	velocity.y = JUMP_VELOCITY
	
func go_to_duck_state():
	status = PlayerState.duck
	animated.play("duck")
	collision_shape.shape.size.x = 29
	collision_shape.shape.size.y = 13
	collision_shape.position.y = 10
	
func exit_from_duck_state():
	collision_shape.shape.size.x = 20
	collision_shape.shape.size.y = 26
	collision_shape.position.y = 3
	
func idle_state():
	move()
	if velocity.x != 0:
		go_to_walk_state()
		return
		
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
	
	if Input.is_action_pressed("duck"):
		go_to_duck_state()
		return
	
func walk_state():
	move()
	if velocity.x == 0:
		go_to_idle_state()
		return
		
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
	
func jump_state():
	move()
	if is_on_floor():
		if velocity.x == 0:
			go_to_idle_state()
		else:
			go_to_walk_state()
		return
		
func duck_state():
	uptade_direction()
	if Input.is_action_just_released("duck"):
		exit_from_duck_state()
		go_to_idle_state()
		return
		
func move():
	uptade_direction()
	
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		
func uptade_direction():
	direction = Input.get_axis("left", "right")
		
	if direction < 0:
		animated.flip_h = true
	elif direction > 0:
		animated.flip_h = false
		
	
	
	
	
	
