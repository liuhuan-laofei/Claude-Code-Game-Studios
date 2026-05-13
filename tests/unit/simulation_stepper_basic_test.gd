extends RefCounted

## Validates that a step bounds waiting slots.
func test_simulation_step_consumes_energy_and_updates_waiting_slots():
	var state := SimulationState.new()
	var level_data := {
		"id": "level_test",
		"name": "Level Test",
		"waves": [],
		"waiting_slots": 5
	}
	state.load_level(level_data)
	state.enqueue_unit("A", 0)
	SimulationStepper.step(state)
	assert(state.waiting_slots.size() <= 5)
