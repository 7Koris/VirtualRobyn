extends MarginContainer

@onready var label = $Label

const text_pool = [
	":3",
	"awa",
	"uwu",
	"awawa",
	"haii",
	'owo',
	"?!",
	"hmm",
	"hfdgkjdf",
	"is u",
	"eepy",
	"<3"
]

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	label.text = text_pool[randi_range(0, text_pool.size()) - 1]
