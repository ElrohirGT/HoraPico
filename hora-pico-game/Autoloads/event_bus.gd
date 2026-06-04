extends Node

signal VehicleSpawned()
signal VehicleDespawned()

signal ElixirChanged(new_elixir_quantity: float)

signal SpeedChanged(isMax: bool)

signal InvokeAbility(source_device_id: int, ability: Enums.Ability, cost: float)

signal AbilityInvoked(source_device_id: int, ability: Enums.Ability)

signal SpeedEnded()

signal GameEnded(winner: String)
