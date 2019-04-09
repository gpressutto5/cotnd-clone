extends TileMap

enum CELL_TYPES { EMPTY = -1, PLAYER, WALL, ENEMY}

func _ready():
  tile_set.tile_set_region(CELL_TYPES.PLAYER, Rect2(100,100,100,100))
  tile_set.tile_set_region(CELL_TYPES.ENEMY, Rect2(100,100,100,100))

func get_cell_entity(coordinates):
	for node in get_children():
		if world_to_map(node.position) == coordinates:
			return(node)

func request_move(entity, direction):
	var cell_start = world_to_map(entity.position)
	var cell_target = cell_start + direction
	
	var cell_target_type = get_cellv(cell_target)
	match cell_target_type:
		CELL_TYPES.EMPTY:
			return update_entity_position(entity, cell_start, cell_target)
		CELL_TYPES.ENEMY:
			var object_entity = get_cell_entity(cell_target)
			if not object_entity:
				return
			object_entity.queue_free()
			set_cellv(cell_target, CELL_TYPES.EMPTY)
			print("Killed enemy on cell %s" % [cell_target])
		CELL_TYPES.PLAYER:
			var entity_name = get_cell_entity(cell_target).get_name()
			print("Cell %s contains %s" % [cell_target, entity_name])

func update_entity_position(entity, cell_start, cell_target):
	set_cellv(cell_target, entity.type)
	set_cellv(cell_start, CELL_TYPES.EMPTY)
	return map_to_world(cell_target) + cell_size / 2
