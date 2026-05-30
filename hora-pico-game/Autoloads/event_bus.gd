extends Node

signal VehicleSpawned()
signal VehicleDespawned()

signal ElixirChanged(new_elixir_quantity: float)

signal InvokeAbility(ability: Enums.Ability, cost: float)
