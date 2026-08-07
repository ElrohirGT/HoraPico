extends Node

signal VehicleSpawned()
signal VehicleDespawned()

signal ElixirChanged(new_elixir_quantity: float)

signal VehicleChanged(new_vehicle: int)

signal InvokeAbility(source_device_id: int, ability: Enums.Ability, cost: float)

signal AbilityInvoked(source_device_id: int, ability: Enums.Ability)

signal SpeedEnded()

signal GameEnded(winner: String)

signal DeviceConnected(device: int)

signal DeviceDisconnected(device: int)

signal ChangeRole(device: int, role: Enums.Role)

signal ChangedRole(device: int, role: Enums.Role)

signal DisplayMenu(id: Enums.Menu)
