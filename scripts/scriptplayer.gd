extends CharacterBody2D

enum PlayerState{
	idle,
	walk,
	jump,
	fall,
	duck,
	dead
}

@onready var animated: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var hitbox_collision_shape: CollisionShape2D = $Hitbox/CollisionShape2D
@onready var reload_timer: Timer = $ReloadTimer


const SPEED = 90.0
const JUMP_VELOCITY = -300.0

var jump_count = 0
@export var max_jump_count = 2
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
		PlayerState.fall:
			fall_state()
		PlayerState.duck:
			duck_state()
		PlayerState.dead:
			dead_state()
		
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
	jump_count += 1
	
func go_to_fall_state():
	status = PlayerState.fall
	animated.play("fall")
	
func go_to_duck_state():
	status = PlayerState.duck
	animated.play("duck")
	collision_shape.shape.size.x = 29
	collision_shape.shape.size.y = 13
	collision_shape.position.y = 10
	
	hitbox_collision_shape.shape.size.x = 20
	hitbox_collision_shape.shape.size.y = 14
	hitbox_collision_shape.position.y = 12
	
func exit_from_duck_state():
	collision_shape.shape.size.x = 20
	collision_shape.shape.size.y = 27
	collision_shape.position.y = 5.5
	
	hitbox_collision_shape.shape.size.x = 20
	hitbox_collision_shape.shape.size.y = 27
	hitbox_collision_shape.position.y = 5.5
	
func go_to_dead_state():
	if status == PlayerState.dead:
		return
	
	status = PlayerState.dead
	animated.play("dead")
	velocity.x = 0
	GameManager.last_scene_path = get_tree().current_scene.scene_file_path #para carregar a ultima fase
	#reload_timer.start() // nao preciso mais
	await animated.animation_finished # novo
	get_tree().change_scene_to_file("res://menu/game_over.tscn") #novo
	
func idle_state():
	move()
		
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		return
	
	if Input.is_action_pressed("duck"):
		go_to_duck_state()
		return
		
	if velocity.x != 0:
		go_to_walk_state()
		return
	
func walk_state():
	move()
	if velocity.x == 0:
		go_to_idle_state()
		return
		
	if Input.is_action_just_pressed("jump"):
		go_to_jump_state()
		
	if !is_on_floor():
		go_to_fall_state()
		return
	
func jump_state():
	move()
	
	if Input.is_action_just_pressed("jump") && can_jump():
		go_to_jump_state()
		return
		
	if velocity.y > 0:
		go_to_fall_state()
		return
		
func fall_state():
	move()
	
	if Input.is_action_just_pressed("jump") && can_jump():
		go_to_jump_state()
		return
	
	if is_on_floor():
		jump_count = 0
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
		
func dead_state():
	pass
		
		
		
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
		
func can_jump() -> bool:
	return jump_count < max_jump_count
	
	
func _on_hitbox_area_entered(area: Area2D) -> void:
	if area.is_in_group("enemies"):
		hit_enemy(area)
	elif area.is_in_group("LethalArea"):
		hit_lethal_area()
		
func _on_hitbox_body_entered(body: Node2D) -> void:
	if body.is_in_group("LethalArea"):
		go_to_dead_state()
			
func hit_enemy(area: Area2D):
	if velocity.y > 0:
		# inimigo morre
		area.get_parent().take_damage()
		go_to_jump_state()
	else:
		#player morre
		go_to_dead_state()
	
func hit_lethal_area():
	go_to_dead_state()
	
func _on_reload_timer_timeout() -> void:
	get_tree().reload_current_scene()
