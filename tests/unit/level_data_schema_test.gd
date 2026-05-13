extends RefCounted

## Validates that in-memory level data matches the JSON schema.
func test_level_schema_validates_example():
	var schema_data := {
		"type": "object",
		"required": ["id", "name", "waves"],
		"properties": {
			"id": {"type": "string"},
			"name": {"type": "string"},
			"waves": {"type": "array"}
		}
	}
	var level_data := {
		"id": "lvl_001",
		"name": "Example",
		"waves": []
	}
	var result := LevelData.validate_schema_data(schema_data, level_data)
	assert(result.is_valid)
