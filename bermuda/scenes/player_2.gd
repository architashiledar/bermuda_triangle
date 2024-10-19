extends CharacterBody2D  # Ensure your player script extends the correct node type

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

# Define souvenirs
var souvenirs = {
	"souvenir1": {"name": "Souvenir 1", "cost": 30},
	"souvenir2": {"name": "Souvenir 2", "cost": 50},
	"souvenir3": {"name": "Souvenir 3", "cost": 70}
}

@onready var animated_sprite = $AnimatedSprite2D  # Reference to the AnimatedSprite2D node

func _process(delta):
	handle_movement()
	
	# Check for interaction input
	if Input.is_action_just_pressed("ui_interact") and can_interact and interaction_target != null:
		interact_with_npc(interaction_target.souvenir_name, interaction_target)

func handle_movement():
	var is_moving = false
	velocity = Vector2.ZERO

	if Input.is_action_pressed("ui_up") or Input.is_action_pressed("w"):
		velocity.y = -500
		is_moving = true
	elif Input.is_action_pressed("ui_down") or Input.is_action_pressed("s"):
		velocity.y = 500
		is_moving = true
	if Input.is_action_pressed("ui_right") or Input.is_action_pressed("d"):
		animated_sprite.flip_h = false
		velocity.x = 500
		is_moving = true
	elif Input.is_action_pressed("ui_left") or Input.is_action_pressed("a"):
		animated_sprite.flip_h = true
		velocity.x = -500
		is_moving = true

	if not is_moving:
		animated_sprite.play("idle")  # Play idle animation if not moving
	else:
		update_animation()  # Update animation if moving

	move_and_slide()  # Move the character based on velocity

# Function to update the player's animation based on the movement direction
func update_animation():
	if velocity.y < 0:
		animated_sprite.play("back")  # Move up
	elif velocity.y > 0:
		animated_sprite.play("front")  # Move down
	elif velocity.x > 0:
		animated_sprite.play("right")  # Move right
	elif velocity.x < 0:
		animated_sprite.play("right")  # Use the right animation for left movement (flipped)

# Function to interact with NPC and offer a deal
func interact_with_npc(souvenir_name, npc):
	# Call the NPC to generate the deal
	npc.offer_deal(souvenir_name, self)

# Function to handle player choices: Accept, Decline, Bargain
func show_player_choices():
	print("What do you want to do? (Accept / Decline / Bargain)")

	# Simulating player input (In a real game, this would be input-based)
	var choice = "bargain"  # This would be player input in the real game

	if choice == "accept":
		accept_deal()
	elif choice == "decline":
		decline_deal()
	elif choice == "bargain":
		bargain_deal()

# Function when player accepts the deal
func accept_deal():
	print("You accepted the deal.")
	apply_deal_result()

# Function when player declines the deal
func decline_deal():
	print("You declined the deal.")

# Function when player bargains the deal
func bargain_deal():
	if randf() < interaction_target.bargain_willingness:  # Accessing the NPC's willingness directly
		print("Bargain successful! The price is reduced.")
		current_deal["cost"] *= 0.5  # 50% off
		current_deal["bargain_attempted"] = true
	else:
		print("Bargaining failed! The NPC cancels the deal.")
		decline_deal()

# Function to apply the deal and update player's status
func apply_deal_result():
	var souvenir_name = current_deal["souvenir_name"]
	total_money_spent += current_deal["cost"]
	current_deals += 1

	# Update stars based on total money saved
	update_stars()

# Function to calculate and assign stars based on money saved
func update_stars():
	var money_saved = 0
	for souvenir_name in ["souvenir1", "souvenir2", "souvenir3"]:
		money_saved += souvenirs[souvenir_name]["cost"]

	if money_saved >= 100:
		stars = 3
	elif money_saved >= 75:
		stars = 2
	elif money_saved >= 50:
		stars = 1
	else:
		stars = 0

	print("You saved " + str(money_saved) + " money and earned " + str(stars) + " stars!")

# Collision functions for NPC interaction
func _on_Area2D_body_entered(body):
	if body.is_in_group("npcs"):  # Check if the body is an NPC
		interaction_target = body  # Set the interaction target to the NPC
		can_interact = true  # Allow interaction

func _on_Area2D_body_exited(body):
	if body.is_in_group("npcs"):
		can_interact = false  # Disable interaction when the player exits the area
		interaction_target = null  # Clear the interaction target
