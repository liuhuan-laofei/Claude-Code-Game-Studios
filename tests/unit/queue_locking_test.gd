extends RefCounted

func test_queue_lock_blocks_next_row_if_front_not_consumed():
	var state := SimulationState.new()
	state.load_level(LevelData.load("res://assets/data/levels/example_level.json"))
	var available := state.get_available_units()
	assert(available.size() == state.columns.size())
	var first := available[0]
	state.enqueue_unit(first["column_id"], first["index"])
	var available_after := state.get_available_units()
	assert(available_after.size() == state.columns.size())
	var next_for_column: Dictionary = {}
	for entry in available_after:
		if entry["column_id"] == first["column_id"]:
			next_for_column = entry
			break
	assert(not next_for_column.is_empty())
	assert(next_for_column["index"] == int(first["index"]) + 1)
