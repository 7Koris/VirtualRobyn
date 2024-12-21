extends Window

var window_offset_y = -200
var window_offset_x = -130

func _ready() -> void:
	self.min_size = Vector2i(400, 200)
	self.size = self.min_size
	await get_tree().create_timer(5).timeout
	queue_free()

func _process(delta: float) -> void:
	position = Vector2(Pet.pet_pos.x + window_offset_x, Pet.pet_pos.y + window_offset_y)
