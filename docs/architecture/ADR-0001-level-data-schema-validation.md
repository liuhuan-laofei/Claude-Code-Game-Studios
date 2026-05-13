# ADR-0001: Level Data Schema Validation

## Status

Accepted

## Date

2026-05-13

## Last Verified

2026-05-13

## Decision Makers

- Design Lead
- Tech Lead

## Summary

Define a minimal, data-driven level schema with deterministic validation logic. Validation will be performed in-memory and reused by both gameplay and editor pipelines.

## Engine Compatibility

| Field | Value |
|-------|-------|
| **Engine** | Godot 4.6 |
| **Domain** | Core |
| **Knowledge Risk** | HIGH |
| **References Consulted** | `docs/engine-reference/godot/VERSION.md` |
| **Post-Cutoff APIs Used** | None |
| **Verification Required** | None |

## ADR Dependencies

| Field | Value |
|-------|-------|
| **Depends On** | None |
| **Enables** | Core simulation and editor save/load |
| **Blocks** | None |
| **Ordering Note** | Must exist before validation logic is relied upon |

## Context

### Problem Statement

We need a consistent, data-driven representation of levels that both the gameplay runtime and the level editor can read and validate deterministically.

### Current State

No shared level schema or validation exists.

### Constraints

- Must be data-driven (no hardcoded gameplay values).
- Validation should be deterministic and reusable in editor and gameplay.

### Requirements

- Define a minimal schema for level data.
- Provide validation that can run without file I/O in unit tests.

## Decision

Create a JSON schema and implement minimal validation that:
- Loads schema and level JSON from disk when needed.
- Uses an in-memory validator for unit tests and other non-I/O contexts.

### Architecture

```
LevelData.load(path) -> Dictionary
LevelData.validate_schema(path, path) -> Dictionary
LevelData.validate_schema_data(schema_dict, level_dict) -> Dictionary
```

### Key Interfaces

```
LevelData.validate_schema_data(schema: Dictionary, level: Dictionary) -> Dictionary
LevelData.validate_schema(schema_path: String, level_path: String) -> Dictionary
```

### Implementation Guidelines

- Keep validation minimal until formal schema enforcement is needed.
- Use validate_schema_data in unit tests to avoid file I/O.

## Alternatives Considered

### Alternative 1: Full JSON Schema Enforcement

- **Description**: Implement full JSON Schema validation immediately.
- **Pros**: Strong guarantees, earlier error detection.
- **Cons**: Larger scope, higher complexity early.
- **Estimated Effort**: Medium
- **Rejection Reason**: Out of scope for MVP.

## Consequences

### Positive

- Shared validation logic across editor and gameplay.
- Deterministic, testable validation without file I/O.

### Negative

- Minimal validation may allow malformed levels until schema enforcement is added.

### Neutral

- JSON schema stored as data and evolves with tooling.

## Risks

| Risk | Probability | Impact | Mitigation |
|------|------------|--------|-----------|
| Minimal validation misses malformed data | Medium | Medium | Expand validation when editor pipeline matures |

## Performance Implications

| Metric | Before | Expected After | Budget |
|--------|--------|---------------|--------|
| CPU (frame time) | N/A | N/A | N/A |
| Memory | N/A | N/A | N/A |
| Load Time | N/A | N/A | N/A |
| Network (if applicable) | N/A | N/A | N/A |

## Migration Plan

1. Add schema and minimal validation.
2. Extend validation when production tooling is ready.

**Rollback plan**: Remove validator calls and rely on raw JSON loading.

## Validation Criteria

- [ ] Unit tests validate in-memory schema and level dictionaries.

## GDD Requirements Addressed

| GDD Document | System | Requirement | How This ADR Satisfies It |
|-------------|--------|-------------|--------------------------|
| Foundational | Core Data | Foundational — no GDD requirement. Enables: gameplay simulation and editor tooling | Establishes shared, deterministic level data validation |

## Related

- `src/core/data/level_data.gd`
