extends Node

const SNAKE = 0
const APPLE = 1
var apple_position
var snake_body = [Vector2(5, 10), Vector2(4, 10), Vector2(3, 10)]
var snake_direction = Vector2(1, 0)
var add_apple = false

func _ready() -> void:
	apple_position = place_apple()
	
	draw_snake()

func place_apple():
	randomize()
	var x = randi() % 20
	var y = randi() % 20
	
	return Vector2(x, y)

func draw_apple():
	$SnakeApple.set_cell(apple_position.x, apple_position.y, APPLE)

func draw_snake():
	for block in snake_body:
		$SnakeApple.set_cell(block.x, block.y, SNAKE, false, false, false, Vector2(8, 0))

func move_snake():
	if add_apple:
		delete_tiles(SNAKE)
		var body_copy = snake_body.slice(0, snake_body.size() - 1)
		var new_head = body_copy[0] + snake_direction
		body_copy.insert(0, new_head)
		snake_body = body_copy
		add_apple = false
	else:
		delete_tiles(SNAKE)
		var body_copy = snake_body.slice(0, snake_body.size() - 2)
		var new_head = body_copy[0] + snake_direction
		body_copy.insert(0, new_head)
		snake_body = body_copy

func delete_tiles(id: int):
	var cells = $SnakeApple.get_used_cells_by_id(id)
	for cell in cells:
		$SnakeApple.set_cell(cell.x, cell.y, -1)

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("ui_up"):
		if not snake_direction == Vector2(0, 1):
			snake_direction = Vector2(0, -1)
	if Input.is_action_just_pressed("ui_right"):
		if not snake_direction == Vector2(-1, 0):
			snake_direction = Vector2(1, 0)
	if Input.is_action_just_pressed("ui_left"):
		if not snake_direction == Vector2(1, 0):
			snake_direction = Vector2(-1, 0)
	if Input.is_action_just_pressed("ui_down"):
		if not snake_direction == Vector2(0, -1):
			snake_direction = Vector2(0, 1)

func check_apple_eaten():
	if apple_position == snake_body[0]:
		apple_position = place_apple()
		add_apple = true

func check_game_over():
	var head = snake_body[0]
	
	if head.x > 20 or head.x < 0 or head.y < 0 or head.y > 20:
		reset()
	
	for block in snake_body.slice(1, snake_body.size() - 1):
		if block == head:
			reset()

func reset():
	snake_body = [Vector2(5, 10), Vector2(4, 10), Vector2(3, 10)]
	snake_direction = Vector2(1, 0)

func _on_SnakeTick_timeout() -> void:
	draw_apple()
	move_snake()
	draw_snake()
	check_apple_eaten()

func _process(delta: float) -> void:
	check_game_over()
