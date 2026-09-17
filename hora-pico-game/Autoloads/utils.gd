extends Node

func format_button_text(prefix_fmt: String, button_text: String, action: String) -> String:
	var prefix = ""
	if InputManager.is_any_joycon_connected():
		prefix = prefix_fmt % get_key_or_button_for_action(action)
	return "%s%s" % [prefix, button_text]

func get_key_or_button_for_action(action: String) -> String:
	var events = InputMap.action_get_events(action)
	var txt = "?"
	for event in events:
		if event is InputEventJoypadButton:
			txt = event.as_text()
	
	if txt != "?":
		var start = txt.find("(")
		var end = txt.find(",", start)
		
		var new_txt = txt.substr(start+1, end-start-1)
		print("txt %s[%d:%d] -> %s" % [txt, start, end, new_txt])
		txt = new_txt
	
	return txt
