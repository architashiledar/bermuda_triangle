extends CharacterBody2D  # Ensure your player script extends the correct node type

# Variables
var total_money_spent = 0
var stars = 0
var current_deal = {
	"souvenir_name": "",
	"cost": 0,
	"is_scammed": false,
	"bargain_attempted": false,
	"npc_name": "Fruit Seller"
}

var current_deals = 0
var max_deals = 3
var clues = []
var can_interact = false  # Track if the player can interact with an NPC
var interaction_target = null  # Reference to the current NPC the player can interact with

# Define souvenirs
var souvenirs = {
	"souvenir1": {"name": "Souvenir 1", "cost": 30},
	"souvenir2": {"name": "Souvenir 2", "cost": 50},
	"souvenir3": {"name": "Souvenir 3", "cost": 70}
}

@onready var animated_sprite = $AnimatedSprite2D  # Reference to the AnimatedSprite2D node
var speed = 1000  # Player movement speed

func _process(delta):
	handle_movement(delta)
	
	# Check for interaction input
	if Input.is_action_just_pressed("ui_interact") and can_interact and interaction_target != null:
		interact_with_npc(interaction_target)

func handle_movement(delta):
	var direction = Vector2.ZERO
	
	# Handle movement based on input
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	
	if direction.length() > 0:
		direction = direction.normalized()
		position += direction * speed * delta
		update_animation(direction)
	else:
		animated_sprite.play("idle")  # Play idle animation if not moving

# Function to update the player's animation based on movement direction
func update_animation(direction):
	if direction.y < 0:
		animated_sprite.play("back")  # Move up
	elif direction.y > 0:
		animated_sprite.play("front")  # Move down
	elif direction.x > 0:
		animated_sprite.flip_h = false
		animated_sprite.play("right")  # Move right
	elif direction.x < 0:
		animated_sprite.flip_h = true
		animated_sprite.play("right")  # Use the right animation for left movement (flipped)

# Function to interact with NPC and offer a deal
func interact_with_npc(npc):
	print("Interacting with " + npc.name)
	npc.offer_deal(current_deal["souvenir_name"], self)  # Pass the current deal's souvenir name

# Collision functions for NPC interaction
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("npcs"):  # Check if the body is an NPC
		interaction_target = body  # Set the interaction target to the NPC
		can_interact = true  # Allow interaction

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("npcs"):
		can_interact = false  # Disable interaction when the player exits the area
		interaction_target = null  # Clear the interaction target


func _on_player_child_entered_tree(node: Node) -> void:
	pass # Replace with function body.
