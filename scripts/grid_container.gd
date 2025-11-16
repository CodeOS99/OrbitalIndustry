extends GridContainer

var prices = [10, 15, 20, 10, 20, 40]
var funcs = [func(): 
		Globals.drone_speed += 50,
	func():
		Globals.rpr += 2,
	func():
		Globals.block_regen = max(0, Globals.block_regen - .5),
	func():
		Globals.rps += 1,
	func():
		Globals.rps += 5,
	func():
		Globals.rps += 20]

func _ready() -> void:
	for i in range(get_child_count()):
		var button = get_child(i) as Button
		if button:
			button.pressed.connect(_on_button_pressed.bind(i))

func _on_button_pressed(index: int) -> void:
	Globals.rocks -= prices[index]
	
	funcs[index].call()

func _process(delta: float) -> void:
	for i in range(get_child_count()):
		get_child(i).disabled = Globals.rocks < prices[i]
