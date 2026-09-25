extends CanvasLayer

@rpc("any_peer", "call_local")
func change_role(peer_id: int, role: Enums.Role):
	print(multiplayer.get_unique_id(), " Received that ", peer_id, " changed role to: ", role)
	EventBus.ChangedRole.emit(peer_id, role)
