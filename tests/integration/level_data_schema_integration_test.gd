extends RefCounted

## Validates that the example level file passes schema validation.
func test_level_schema_validates_example_file():
	var schema_path := "res://assets/data/levels/level_schema.json"
	var level_path := "res://assets/data/levels/example_level.json"
	var result := LevelData.validate_schema(schema_path, level_path)
	assert(result.is_valid)
