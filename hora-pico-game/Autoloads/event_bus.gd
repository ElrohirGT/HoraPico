extends Node

signal VehicleSpawned()
signal VehicleDespawned()

signal ElixirChanged(new_elixir_quantity: float)

signal SpeedChanged(isMax: bool)

signal InvokeAbility(ability: Enums.Ability, cost: float)

signal AbilityInvoked(ability: Enums.Ability)
