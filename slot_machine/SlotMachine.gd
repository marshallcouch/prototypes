extends Node2D

var slots_spinning = [false, false, false]
var score = 0
var max_wrap = 9
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	var slot1 = int($SlotsLayout/SlotContainer1/slot_text.text)
	var slot2 = int($SlotsLayout/SlotContainer2/slot_text.text)
	var slot3 = int($SlotsLayout/SlotContainer3/slot_text.text)
	if slots_spinning[0]:
		if slot1 == max_wrap:
			 $SlotsLayout/SlotContainer1/slot_text.text = str(0)
		else:
			$SlotsLayout/SlotContainer1/slot_text.text = str(slot1 + 1)
	if slots_spinning[1]:
			if slot2 == max_wrap:
				 $SlotsLayout/SlotContainer2/slot_text.text = str(0)
			else:
				$SlotsLayout/SlotContainer2/slot_text.text = str(slot2 + 1)
	if slots_spinning[2]:
			if slot3 == max_wrap:
				 $SlotsLayout/SlotContainer3/slot_text.text = str(0)
			else:
				$SlotsLayout/SlotContainer3/slot_text.text = str(slot3 + 1)



func _on_Button_button_down() -> void:
	if slots_spinning[0]:
		slots_spinning[0] = false
		return
	elif slots_spinning[1]:
		slots_spinning[1] = false
		return
	elif slots_spinning[2]:
		slots_spinning[2] = false
		set_outcome()
		return
	else:
		for i in range(0,3):
			slots_spinning[i]= true;
			$outcome.text = "Spinning..."
		
		
func set_outcome() -> void:
	var slot1 = int($SlotsLayout/SlotContainer1/slot_text.text)
	var slot2 = int($SlotsLayout/SlotContainer2/slot_text.text)
	var slot3 = int($SlotsLayout/SlotContainer3/slot_text.text)
	var slots = [slot1, slot2, slot3]
	
	if slot1 == slot2:
		if slot2 == slot3:
			if slot1 == 7:
				$outcome.text = "Top Catch!!!"
				score += 20
				$score.text = str(score)
				return
			else:
				$outcome.text = "Not Bad!"
				score += 10
				$score.text = str(score)
				return
				
				
	if slot1 == slot2 + 1:
		if slot2 == slot3 + 1:
			$outcome.text = "Positive Run!"
			score += 5
			$score.text = str(score)

			return
			
	if slot1 == slot2 - 1:
		if slot2 == slot3 - 1:
			$outcome.text = "Positive Run!"
			score += 5
			$score.text = str(score)

			return
			
	if slot1 == slot2 or slot1 == slot3 or slot3 == slot2:
			$outcome.text = "Two Pair!"
			score += 2
			$score.text = str(score)
			return
		

	$outcome.text = "Better luck next time!"
	
	
				
