extends RefCounted

## Validates that a step bounds waiting slots.
func test_simulation_step_consumes_energy_and_updates_waiting_slots():
	var state := SimulationState.new()
	state.load_level(LevelData.load("res://assets/data/levels/example_level.json"))
	state.enqueue_unit("A", 0)
	SimulationStepper.step(state)
	assert(state.waiting_slots.size() <= 5)
