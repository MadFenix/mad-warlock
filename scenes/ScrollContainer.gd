extends ScrollContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	get_v_scroll_bar().custom_minimum_size.x = 50
	get_v_scroll_bar().custom_minimum_size.y = 200
	get_h_scroll_bar().custom_minimum_size.y = 50
	get_h_scroll_bar().custom_minimum_size.x = 200
