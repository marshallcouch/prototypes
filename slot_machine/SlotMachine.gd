extends Node2D

var slots_spinning = [false, false, false]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	var slot1 = int($SlotsLayout/SlotContainer1/slot_text.text)
	var slot2 = int($SlotsLayout/SlotContainer2/slot_text.text)
	var slot3 = int($SlotsLayout/SlotContainer3/slot_text.text)
	if slots_spinning[0]:
		if slot1 == 9:
			 $SlotsLayout/SlotContainer1/slot_text.text = str(0)
		else:
			$SlotsLayout/SlotContainer1/slot_text.text = str(slot1 + 1)
	if slots_spinning[1]:
			if slot2 == 9:
				 $SlotsLayout/SlotContainer2/slot_text.text = str(0)
			else:
				$SlotsLayout/SlotContainer2/slot_text.text = str(slot2 + 1)
	if slots_spinning[2]:
			if slot3 == 9:
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
		return
	else:
		for i in range(0,3):
			slots_spinning[i]= true;
		
