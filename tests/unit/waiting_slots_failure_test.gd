extends RefCounted

func test_waiting_slots_overflow_triggers_failure():
	var state := SimulationState.new()
	state.waiting_slots = [1, 2, 3, 4, 5]
	assert(state.is_failed())
