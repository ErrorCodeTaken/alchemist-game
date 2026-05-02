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
	$ItemLabel.text = "Current Item: Willow Bark"
	$SelectionLabel.text = "Actions: None"


func _on_plant_b_pressed() -> void:
	if is_busy:
		return
	
	selected_plant = "B"
	$ItemLabel.text = "Current Item: Glassleaf"
	$SelectionLabel.text = "Actions: None"

func get_action_history_text() -> String:
	if actions.size() == 0:
		return "You delivered it raw."

	var readable_actions = []

	for action in actions:
		if action == "cut":
			readable_actions.append("cut it")
		elif action == "crush":
			readable_actions.append("crushed it")
		elif action == "boil":
			readable_actions.append("boiled it")

	return "You " + ", then ".join(readable_actions) + "."



func _on_deliver_pressed() -> void:
	if is_busy:
		return
	
	if selected_plant == "":
		$Label.text = "Select a plant first"
		return

	is_busy = true
	
	var result = "This does not seem suited for the customer's symptoms."
	
	#Willow Bark/Plant A - Headache
	if current_request == "headache" and selected_plant == "A":
		var has_boil = "boil" in actions
		var has_crush = "crush" in actions
		var great = false
	
		if has_boil:
			var boil_index = actions.find("boil")
			var crushed_before = false
		
			for i in range(boil_index):
				if actions[i] == "crush":
					crushed_before = true
		
			if crushed_before:
				great = true
	
		if great:
			result = "Strong treatment. Crushing before boiling released more from the bark."
		elif has_boil: 
			result = "The tea helped, but it feels weak. Maybe the bark needs preparing first."
		elif has_crush:
			result = "The bark seems useful, but crushing alone did not release enough."
		else:
			result = "The bark seems to help a little, but it is too weak raw."
			
		$Label.text = result + "\n" + get_action_history_text()
		
		selected_plant = ""
		actions.clear()
		$ItemLabel.text = "Current Item: None"
		$SelectionLabel.text = "Actions: None"
		await get_tree().create_timer(3).timeout
		show_request()
		is_busy = false
		return
	
	#Glassleaf / Plant B - Rash
	if current_request == "rash" and selected_plant == "B":
		var has_cut = "cut" in actions
		var has_crush = "crush" in actions
		var has_boil = "boil" in actions

		if has_boil:
			result = "The heat ruined the gel. It became watery and lost its soothing effect."
		elif has_cut and has_crush:
			result = "Good paste. The gel spread evenly over the rash."
		elif has_cut:
			result = "The exposed gel calmed the skin, but only slightly."
		elif has_crush:
			result = "The crushed leaf made a messy paste, but it was not very effective."
		else:
			result = "This plant seems suited for skin, but it needs to be cut first."

		$Label.text = result + "\n" + get_action_history_text()

		selected_plant = ""
		actions.clear()
		$SelectionLabel.text = "Actions: None"

		await get_tree().create_timer(3).timeout
		show_request()
		is_busy = false
		return
	
		
	selected_plant = ""
	actions.clear()
	$SelectionLabel.text = "Selected: None"
	await get_tree().create_timer(3).timeout
	show_request()
	is_busy = false
		

func update_item_label() -> void:
	if selected_plant == "A":
		if "boil" in actions:
			if actions.find("boil") == 0:
				$ItemLabel.text = "Current Item: Weak Willow Infusion"
			elif "crush" in actions:
				$ItemLabel.text = "Current Item: Willow Tea"
			elif "cut" in actions:
				$ItemLabel.text = "Current Item: Rough Willow Tea"
			else:
				$ItemLabel.text = "Current Item: Weak Willow Infusion"
		elif "crush" in actions:
			$ItemLabel.text = "Current Item: Crushed Willow Bark"
		elif "cut" in actions:
			$ItemLabel.text = "Current Item: Willow Bark Cuttings"
		else:
			$ItemLabel.text = "Current Item: Willow Bark"

	elif selected_plant == "B":
		if "boil" in actions:
			$ItemLabel.text = "Current Item: Ruined Glassleaf Gel"
		elif "crush" in actions:
			$ItemLabel.text = "Current Item: Glassleaf Paste"
		elif "cut" in actions:
			$ItemLabel.text = "Current Item: Opened Glassleaf"
		else:
			$ItemLabel.text = "Current Item: Glassleaf"


func _on_crush_pressed() -> void:
	if is_busy:
		return
	
	if selected_plant == "":
		$SelectionLabel.text = "Select a plant first"
		return
	
	if not "cut" in actions:
		$SelectionLabel.text = "You need to cut it first"
		return
	
	actions.append("crush")
	$SelectionLabel.text = "Actions: " + ", ".join(actions).capitalize()
	update_item_label()


func _on_boil_pressed() -> void:
	if is_busy:
		return
	
	actions.append("boil")
	$SelectionLabel.text = "Actions: " + ", ".join(actions).capitalize()
	update_item_label()

func _on_cut_pressed() -> void:
	if is_busy:
		return
	
	actions.append("cut")
	$SelectionLabel.text = "Actions: " + ", ".join(actions).capitalize()
	update_item_label()

func _on_clear_actions_pressed() -> void:
	if is_busy:
		return
	
	actions.clear()
	$SelectionLabel.text = "Actions: None"
