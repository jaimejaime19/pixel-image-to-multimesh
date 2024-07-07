extends GridMap

#func _ready():
	#for i in get_used_cells():
		#set_cell_item(Vector3i(i.x, i.y, i.z), 0, randi_range(1, 1))

var count: int = 0
var pattern_0_10_16_22: int = 0

func _input(event):
	if event.is_action_pressed("sss"):
		spin()
	elif event.is_action_pressed("restart"):
		restart()
	elif event.is_action_pressed("top_rot"):
		spin_0_10_16_22()

func spin():
	count += 1
	if count == 24:
		count = 0
	print("current count: " + str(count))
	for i in get_used_cells():
		set_cell_item(Vector3i(i.x, i.y, i.z), 0, count)
		

func restart():
	count = -1
	spin()

func spin_0_10_16_22():
	pattern_0_10_16_22 += 1
	if pattern_0_10_16_22 == 4:
		pattern_0_10_16_22 = 0
	var spiinny: int = 0
	match pattern_0_10_16_22:
		0: 
			spiinny = 0
		1:
			spiinny = 10
		2:
			spiinny = 16
		3:
			spiinny = 22
	for j in get_used_cells():
		set_cell_item(Vector3i(j.x, j.y, j.z), 0, spiinny)
