extends Control

var actions = []
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
		var has_boil = "boil" in actions
		var great = false
	
		if has_boil:
			var boil_index = actions.find("boil")
			var crushed_before = false
		
			for i in range(boil_index):
				if actions[i] == "crush":
					crushed_before = true
		
			if crushed_before:
				great = true
	
		if has_boil:
			if great:
				$Label.text = "Great choice!"
			else:
				$Label.text = "It helped, but weak"
		else:
			$Label.text = "That didn't help..."
	
		selected_plant = ""
		actions.clear()
		$SelectionLabel.text = "Actions: None"
		await get_tree().create_timer(1.5).timeout
		show_request()
		is_busy = false
		return
	
	if current_request == "rash" and selected_plant == "B":
		var has_cut = "cut" in actions
		var has_crush = "crush" in actions
		var has_boil = "boil" in actions

		var result = "That didn't help..."

		if has_boil:
			# Boiling damages aloe
			if has_cut:
				result = "It helped, but weak"
			else:
				result = "That didn't help..."
		else:
			if has_cut and has_crush:
				result = "Good treatment"
			elif has_cut:
				result = "It helped"
			elif has_crush:
				result = "That didn't help..."
			else:
				result = "That didn't help..."

		$Label.text = result

		selected_plant = ""
		actions.clear()
		$SelectionLabel.text = "Actions: None"

		await get_tree().create_timer(1.5).timeout
		show_request()
		is_busy = false
		return
	
		
	selected_plant = ""
	actions.clear()
	$SelectionLabel.text = "Selected: None"
	await get_tree().create_timer(1.5).timeout
	show_request()
	is_busy = false
		


func _on_crush_pressed() -> void:
	if is_busy:
		return
	
	actions.append("crush")
	$SelectionLabel.text = "Actions: " + ", ".join(actions).capitalize()


func _on_boil_pressed() -> void:
	if is_busy:
		return
	
	actions.append("boil")
	$SelectionLabel.text = "Actions: " + ", ".join(actions).capitalize()


func _on_cut_pressed() -> void:
	if is_busy:
		return
	
	actions.append("cut")
	$SelectionLabel.text = "Actions: " + ", ".join(actions).capitalize()


func _on_clear_actions_pressed() -> void:
	if is_busy:
		return
	
	actions.clear()
	$SelectionLabel.text = "Actions: None"
