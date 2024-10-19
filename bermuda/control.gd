extends Control



## Function to handle starting the game
#func _on_StartButton_pressed():
	## Replace 'res://path_to_your_game_scene.tscn' with the path to your main game scene
	#get_tree().change_scene("res://scenes/node_2d.tscn")
#
## Function to handle quitting the game
#func _on_QuitButton_pressed():
	#get_tree().quit()
#
#
#func _on_size_flags_changed() -> void:
	#pass # Replace with function body.


func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scenes/node_2d.tscn")
	


func _on_quit_button_pressed() -> void:
	get_tree().quit()
