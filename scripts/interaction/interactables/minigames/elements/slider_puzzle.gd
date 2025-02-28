class_name SliderPuzzle
extends MinigameElement

# Configuration
@export var grid_size: Vector2i = Vector2i(3, 3)
@export var move_time: float = 0.5
@export var shuffle_count: int = 20

# Game state
var tiles: Array[int] = []
var empty_position: Vector2i
var is_active: bool = false
var can_move: bool = true
var solved: bool = false

# Override the start method
func start() -> void:
	is_active = true
	_initialize_puzzle()
	_shuffle_puzzle()
	
# Override the stop method
func stop() -> void:
	is_active = false

# Check if the puzzle is solved
func _check_solved() -> bool:
	for y in range(grid_size.y):
		for x in range(grid_size.x):
			var pos: Vector2i = Vector2i(x, y)
			var index: int = y * grid_size.x + x
			
			# Skip the empty tile position
			if pos == empty_position:
				continue
				
			# Check if tile is in correct position
			if tiles[index] != index:
				return false
				
	return true

# Initialize the puzzle grid
func _initialize_puzzle() -> void:
	# Implementation would create the initial tile arrangement
	tiles.clear()
	for i in range(grid_size.x * grid_size.y - 1):
		tiles.append(i)
	
	# Last position is empty
	tiles.append(-1)
	empty_position = Vector2i(grid_size.x - 1, grid_size.y - 1)

# Shuffle the puzzle
func _shuffle_puzzle() -> void:
	# Implementation would randomize the tiles
	for i in range(shuffle_count):
		var possible_moves: Array[Vector2i] = _get_possible_moves()
		if possible_moves.size() > 0:
			var move: Vector2i = possible_moves[randi() % possible_moves.size()]
			_move_tile(move)

# Get positions of tiles that can be moved
func _get_possible_moves() -> Array[Vector2i]:
	var moves: Array[Vector2i] = []
	
	# Check all four directions
	var directions: Array[Vector2i] = [
		Vector2i(0, -1), # Up
		Vector2i(0, 1),  # Down
		Vector2i(-1, 0), # Left
		Vector2i(1, 0)   # Right
	]
	
	for dir in directions:
		var pos: Vector2i = empty_position + dir
		if pos.x >= 0 and pos.x < grid_size.x and pos.y >= 0 and pos.y < grid_size.y:
			moves.append(pos)
			
	return moves

# Move a tile to the empty position
func _move_tile(tile_position: Vector2i) -> void:
	# Implementation would move the tile
	var index: int = tile_position.y * grid_size.x + tile_position.x
	var empty_index: int = empty_position.y * grid_size.x + empty_position.x
	
	# Swap the tile with empty space
	tiles[empty_index] = tiles[index]
	tiles[index] = -1
	
	# Update empty position
	empty_position = tile_position
	
	# Check if puzzle is solved
	if _check_solved():
		solved = true
		emit_signal("completed")

# Handle user input
func _input(event: InputEvent) -> void:
	if not is_active or not can_move:
		return
		
	if event is InputEventMouseButton and event.pressed:
		# Convert mouse position to grid position
		# Implementation would determine which tile was clicked
		var clicked_pos: Vector2i = Vector2i(0, 0) # Placeholder
		
		# Check if the clicked tile can be moved
		var possible_moves: Array[Vector2i] = _get_possible_moves()
		if clicked_pos in possible_moves:
			_move_tile(clicked_pos)
			
	elif event.is_action_pressed("ui_up"):
		var move_pos: Vector2i = empty_position + Vector2i(0, 1)
		if move_pos.y < grid_size.y:
			_move_tile(move_pos)
			
	elif event.is_action_pressed("ui_down"):
		var move_pos: Vector2i = empty_position + Vector2i(0, -1)
		if move_pos.y >= 0:
			_move_tile(move_pos)
			
	elif event.is_action_pressed("ui_left"):
		var move_pos: Vector2i = empty_position + Vector2i(1, 0)
		if move_pos.x < grid_size.x:
			_move_tile(move_pos)
			
	elif event.is_action_pressed("ui_right"):
		var move_pos: Vector2i = empty_position + Vector2i(-1, 0)
		if move_pos.x >= 0:
			_move_tile(move_pos)

# Draw the puzzle
func _draw() -> void:
	if not is_active:
		return
		
	# Implementation would draw the puzzle grid and tiles
	# This would be specific to how you want to represent the slider puzzle visually
