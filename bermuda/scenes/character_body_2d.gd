extends CharacterBody2D

# Variables
var total_money_spent = 0
var stars = 0
var current_deal = {
	"souvenir_name": "",
	"cost": 0,
	"is_scammed": false,
	"bargain_attempted": false,
	"npc_name": ""
}

var current_deals = 0
var max_deals = 3
var clues = []
var can_interact = false  # Track if the player can interact with an NPC
var interaction_target = null  # Reference to the current NPC the player can interact with

@onready var animated_sprite = $AnimatedSprite2D  # Reference to the AnimatedSprite2D node
@onready var collision_shape = $CollisionShape2D  # Reference to the player's collision shape

# Movement variables
var speed = 300  # Adjust speed to your preference

func _process(_delta):
	handle_movement()

	# Check for interaction input
	if Input.is_action_just_pressed("ui_interact") and can_interact and interaction_target != null:
		interact_with_npc()

func handle_movement():
	var is_moving = false
	velocity = Vector2.ZERO

	# Handle input for movement
	if Input.is_action_pressed("ui_up"):
		velocity.y = -speed
		is_moving = true
	elif Input.is_action_pressed("ui_down"):
		velocity.y = speed
		is_moving = true
	
	if Input.is_action_pressed("ui_right"):
		animated_sprite.flip_h = false
		velocity.x = speed
		is_moving = true
	elif Input.is_action_pressed("ui_left"):
		animated_sprite.flip_h = true
		velocity.x = -speed
		is_moving = true
		
	# Handle animations based on movement state
	if not is_moving:
		animated_sprite.play("idle")
	else:
		update_animation()

	# Move the character and handle collision
	move_and_slide()

	# Prevent the player from walking over the NPC
	if interaction_target != null:
		prevent_walking_over_npc(interaction_target)

# Function to update the player's animation based on movement
func update_animation():
	if velocity.y < 0:
		animated_sprite.play("back")  # Move up
	elif velocity.y > 0:
		animated_sprite.play("front")  # Move down
	elif velocity.x > 0:
		animated_sprite.play("right")  # Move right
	elif velocity.x < 0:
		animated_sprite.play("right")  # Use the right animation for left movement (flipped)

# Function to interact with NPC
func interact_with_npc():
	if interaction_target != null:
		interaction_target.offer_deal("souvenir1", self)

# Handle NPC interaction on entering NPC's area
func _on_Area2D_body_entered(body):
	if body.is_in_group("npcs"):
		interaction_target = body  # Set NPC as the interaction target
		can_interact = true  # Allow interaction

# Handle exiting the NPC's area
func _on_Area2D_body_exited(body):
	if body.is_in_group("npcs"):
		can_interact = false  # Disable interaction
		interaction_target = null  # Clear the interaction target

# Prevent the player from walking over the NPC
func prevent_walking_over_npc(npc):
	# Check if the player has collided with the NPC
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		if collision.collider == npc:
			# Stop movement if colliding with the NPC
			velocity = Vector2.ZERO  
			move_and_slide()  # Ensure player does not overlap with the NPC
			break  # Exit loop after stopping movement
