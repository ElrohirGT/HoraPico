extends Node

signal Spawn(spawner_id: String, obj: Node2D)

signal ElixirChanged(new_elixir_quantity: float)

signal SpeedChanged(isMax: bool)

signal InvokeAbility(ability: Enums.Ability, cost: float)
