extends RefCounted

## Validates that saving then loading returns identical data.
func test_level_roundtrip_save_load():
	var dir := DirAccess.open("user://")
	if dir != null:
		dir.remove("levels/tmp.json")
	var level := LevelData.load("res://assets/data/levels/example_level.json")
	LevelData.save("user://levels/tmp.json", level)
	var loaded := LevelData.load("user://levels/tmp.json")
	assert(level == loaded)
