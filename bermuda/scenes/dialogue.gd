extends CanvasLayer

# Exported variable to select a JSON file
export (String, FILE, "*.json") var d_file

var dialogue = []

func _ready():
	start()

func start():
	dialogue = load_dialogue()

	# Display the first dialogue entry if available
	if dialogue.size() > 0:  # Ensure there is at least one entry
		$NLnePatchRect/Name.text = dialogue[0]['name']
		$NLnePatchRect/Chat.text = dialogue[0]['text']

func load_dialogue() -> Array:
	var file = File.new()
	if file.file_exists(d_file):
		file.open(d_file, File.READ)
		var result = parse_json(file.get_as_text())
		file.close()  # Close the file after reading
		return result
	else:
		print("Dialogue file does not exist.")
		return []
