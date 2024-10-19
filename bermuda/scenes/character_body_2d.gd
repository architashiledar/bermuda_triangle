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
var speed = 1500  # Adjust speed to your preference

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
		
	elif Input.is_action_pressed("ui_down"):
		velocity.y = speed
	
	if Input.is_action_pressed("ui_right"):
		animated_sprite.flip_h = false
		velocity.x = speed
		
	elif Input.is_action_pressed("ui_left"):
		animated_sprite.flip_h = true
		velocity.x = -speed
		
	if not is_moving:
		animated_sprite.play("idle")
	else:
		update_animation()

	# Use move_and_slide to handle collisions with NPCs and other objects
	move_and_slide()

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

# Signal handler for entering NPC's area
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("npcs"):  # Check if the body belongs to the NPC group
		interaction_target = body  # Set the NPC as the current interaction target
		can_interact = true  # Allow interaction when in range

# Signal handler for exiting NPC's area
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("npcs"):  # Check if the body belongs to the NPC group
		can_interact = false  # Disable interaction when the player exits the NPC's area
		interaction_target = null  # Clear the interaction target
