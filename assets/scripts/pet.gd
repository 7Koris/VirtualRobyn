extends Node2D

@onready var Sprite = $AnimatedSprite2D
@onready var Emitter: CPUParticles2D = $CPUParticles2D
@onready var MainWindow: Window = get_window()
@onready var dialog = preload("res://assets/scenes/bubble.tscn")

static var rng = RandomNumberGenerator.new()
static var states = [STATE.IDLE, STATE.LOOKAROUND, STATE.WALK, STATE.SLEEP, STATE.SCARE, STATE.JUMP, STATE.SLIP]
static var weights = [1, 0.3, 1, 0.1, 0.1, 0.1, 0.1]

const WALK_SPEED = 150 # * SPEED_SCALE
var pet_state : int = STATE.IDLE
var _looking_right: bool = false
var walk_direction: int = -1 # -1 for left
var grabbed: bool = false
var pet_pos: Vector2 = Vector2.ZERO

var pet_size: Vector2i = Vector2i(100,104)
var taskbar_pos: int = (DisplayServer.screen_get_usable_rect().size.y - pet_size.y)
var screen_width: int = DisplayServer.screen_get_usable_rect().size.x
var g = ProjectSettings.get_setting("physics/2d/default_gravity")

enum STATE{
	IDLE,
	LOOKAROUND,
	WALK,
	SLEEP,
	SCARE,
	JUMP,
	SLIP
}

func _ready():
	MainWindow.min_size = pet_size
	MainWindow.size = MainWindow.min_size
	update_pet_pos(Vector2i(DisplayServer.screen_get_size().x/2 - (pet_size.x/2), taskbar_pos))
	
	pet_state = rng.rand_weighted(weights)
	if pet_state == STATE.WALK:
		set_looking_right(randi() % 2)
	update_animation()
	get_tree().create_timer(randf_range(0,120)).connect("timeout", _on_dialog_timeout)
	
	
func _on_dialog_timeout():
	add_child(dialog.instantiate())

func _process(delta: float) -> void:
	if selected:
		follow_mouse()
		Sprite.play("drag")
	elif Sprite.animation == "drag" and not selected:
		update_animation()
	check_selected()
	if selected:
		return
	
	if pet_state == STATE.WALK:
		walk(delta)
	
	if (pet_pos.y <= taskbar_pos) and not selected:
		update_pet_pos(Vector2(pet_pos.x, pet_pos.y + g * delta))
	
	if Input.is_action_just_pressed("pet"):
		Emitter.emitting = true


func _on_timer_timeout():
	pet_state = rng.rand_weighted(weights)
	if pet_state == STATE.WALK:
		set_looking_right(randi() % 2)
	update_animation()


func update_pet_pos(pp: Vector2):
	pp.y = clampf(pp.y, -10000, taskbar_pos)
	pet_pos = pp
	MainWindow.position = pp


func set_looking_right(looking_right: bool):
	_looking_right = looking_right
	Sprite.flip_h = looking_right
	walk_direction = 1 if !looking_right else -1


func walk(delta):
	update_pet_pos(Vector2(pet_pos.x + WALK_SPEED * walk_direction * delta, pet_pos.y))
	MainWindow.position.x = clampi(MainWindow.position.x, 0, clampi(MainWindow.position.x, 0, screen_width - pet_size.x))
	pet_pos.x = clampf(pet_pos.x, 0, clampf(pet_pos.x, 0, screen_width - pet_size.x))
	
	if ((MainWindow.position.x == (screen_width - pet_size.x)) or (MainWindow.position.x == 0)):
		set_looking_right(!_looking_right)


var selected: bool = false
var mouse_offset: Vector2 = Vector2.ZERO
func follow_mouse():
	update_pet_pos(Vector2(clampf((get_global_mouse_position().x  + mouse_offset.x), 0, screen_width - pet_size.x), get_global_mouse_position().y + mouse_offset.y))
	
func check_selected():
	if Input.is_action_pressed("move"):
		selected = true
		mouse_offset = MainWindow.position - Vector2i(get_global_mouse_position())
	if Input.is_action_just_released("move"):
		selected = false


func update_animation():
	match pet_state:
		STATE.IDLE:
			get_tree().create_timer(randi_range(5, 20)).connect("timeout", _on_timer_timeout)
			Sprite.play("idle")
		STATE.LOOKAROUND:
			get_tree().create_timer(randi_range(1, 3)).connect("timeout", _on_timer_timeout)
			Sprite.play("look_around")
		STATE.WALK:
			get_tree().create_timer(randi_range(6, 30)).connect("timeout", _on_timer_timeout)
			Sprite.play("walk")
		STATE.SLEEP:
			get_tree().create_timer(randi_range(60, 360)).connect("timeout", _on_timer_timeout)
			Sprite.play("sleep")
		STATE.SCARE:
			get_tree().create_timer(randi_range(3, 10)).connect("timeout", _on_timer_timeout)
			Sprite.play("scare")
		STATE.JUMP:
			get_tree().create_timer(randi_range(2, 2)).connect("timeout", _on_timer_timeout)
			Sprite.play("jump")
		STATE.SLIP:
			get_tree().create_timer(randi_range(3, 10)).connect("timeout", _on_timer_timeout)
			Sprite.play("slip")
