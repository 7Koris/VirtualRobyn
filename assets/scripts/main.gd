extends Node2D

@onready var _MainWindow: Window = get_window()
@onready var pet: Pet = $Pet
@onready var emitter: CPUParticles2D = $Pet/CPUParticles2D

const pet_scale: int = 1
const SPEED_SCALE: int = 1

var pet_size: Vector2i = Vector2i(100,104)
var mouse_offset: Vector2 = Vector2.ZERO
var selected: bool = false
var taskbar_pos: int = (DisplayServer.screen_get_usable_rect().size.y - pet_size.y)
var screen_width: int = DisplayServer.screen_get_usable_rect().size.x
var is_walking: bool = false
const WALK_SPEED = 150 # * SPEED_SCALE

var pet_pos: Vector2 = Vector2.ZERO
