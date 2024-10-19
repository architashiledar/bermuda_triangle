extends CharacterBody2D

var npc_name = "NPC1"
var fairness = 0.5  # Default fairness
var bargain_willingness = 0.5  # Default bargain willingness

var souvenirs = {
	"souvenir1": {"cost": 100, "bought": false},
	"souvenir2": {"cost": 150, "bought": false},
	"souvenir3": {"cost": 200, "bought": false}
}
var choices = {
	"buy": "Buy the souvenir",
	"haggle": "Try to haggle for a better price",
	"walk_away": "Walk away from the deal"
}

func offer_deal(souvenir_name, player):
	
	var cost = souvenirs[souvenir_name]["cost"]
	var is_scammed = randf() > fairness  # NPC fairness affects scamming

	if is_scammed:
		cost *= 1.5  
		
	player.current_deal["souvenir_name"] = souvenir_name
	player.current_deal["cost"] = cost
	player.current_deal["is_scammed"] = is_scammed
	player.current_deal["npc_name"] = npc_name

	update_npc_expression("offer")
	npc_dialogue("offer")
	
	player.show_player_choices(choices)
	
func update_npc_expression(action):
	if action == "offer":
		print(npc_name + " has a neutral expression, trying to be fair.")
	elif action == "bargain_success":
		print(npc_name + " looks frustrated after bargaining.")
	elif action == "accept":
		print(npc_name + " smiles, pleased with the deal.")
	elif action == "decline":
		print(npc_name + " shrugs, slightly annoyed.")

# Function to handle NPC dialogue
func npc_dialogue(action):
	if action == "offer":
		print(npc_name + " says: 'This is the best deal you'll find!'")
	elif action == "bargain_success":
		print(npc_name + " says: 'Alright, I can lower the price... just for you.'")
	elif action == "decline":
		print(npc_name + " says: 'You're missing out!'")
	elif action == "accept":
		print(npc_name + " says: 'Smart choice, I hope you enjoy it!'")

# Signal handler for player entering NPC's Area2D
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  # Check if the player entered the area
		print("Player is near " + npc_name)
		

# Signal handler for player exiting NPC's Area2D
func _on_area_2d_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):  # Check if the player exited the area
		print("Player left " + npc_name)
		
