extends Node

signal Spawn(spawner_id: String, obj: Node2D)

signal ElixirChanged(new_elixir_quantity: float)

signal InvokeAbility(ability: Enums.Ability, cost: float)
