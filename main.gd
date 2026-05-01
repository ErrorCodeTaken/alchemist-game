extends Control

var is_busy = false
var selected_plant = ""
var current_request = ""
var requests = ["headache", "rash"]
# Called when the node enters the scene tree for the first time.

func show_request():
		current_request = requests.pick_random()
		
		if current_request =="headache":
			$Label.text = "Customer: My head hurts"
		elif current_request == "rash":
			$Label.text = "Customer: My skin is itchy"

func _ready():
	show_request()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_plant_a_pressed() -> void:
	if is_busy:
		return
	
	selected_plant = "A"
	$SelectionLabel.text = "Selected: Plant A"


func _on_plant_b_pressed() -> void:
	if is_busy:
		return
	
	selected_plant = "B"
	$SelectionLabel.text = "Selected: Plant B"


func _on_deliver_pressed() -> void:
	if is_busy:
		return
	
	if selected_plant == "":
		$Label.text = "Select a plant first"
		return

	is_busy = true
	
	var correct = false
	
	if current_request == "headache" and selected_plant == "A":
		correct = true
	elif current_request == "rash" and selected_plant == "B":
		correct = true
		
	if correct:
		$Label.text = "Good Choice!"
	else:
		$Label.text = "That didn't help..."
		
	selected_plant = ""
	$SelectionLabel.text = "Selected: None"
	await get_tree().create_timer(1.5).timeout
	show_request()
	is_busy = false
		
