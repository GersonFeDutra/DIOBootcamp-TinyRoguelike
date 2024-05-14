class_name DeviceDetector

# Enum to represent different joypad types
enum JoypadType {
	GENERIC,
	XBOX,
	NINTENDO,
	SONY
}

# Dictionary to map joypad names/ids to types
const JOYPAD_MAPPINGS = {
	"XInput": JoypadType.XBOX,
	"Wireless Controller": JoypadType.SONY,
	"Pro Controller": JoypadType.NINTENDO,
	# Add more mappings as needed
}


static func get_detected_joypads() -> Array[JoypadType]:
	var joypads: Array[JoypadType] = []
	for joypad_id in Input.get_connected_joypads():
		joypads.append(get_joypad_type(joypad_id))
		#print("Joypad ID: %d, Name: %s, Type: %s" % [
				#joypad_id, joypad_name,
				#joypad_type_to_string(joypad_type)])
	return joypads


static func get_joypad_type(id: int) -> JoypadType:
	var joypad_name = Input.get_joy_name(id)
	return get_joypad_type_from_name(joypad_name)


static func get_joypad_type_from_name(name: String) -> JoypadType:
	for key in JOYPAD_MAPPINGS.keys():
		if name.find(key) != -1:
			return JOYPAD_MAPPINGS[key]
	return JoypadType.GENERIC


static func joypad_type_to_string(joypad_type: JoypadType) -> String:
	match joypad_type:
		JoypadType.XBOX:
			return "Xbox"
		JoypadType.NINTENDO:
			return "Nintendo"
		JoypadType.SONY:
			return "Sony PlayStation"
		JoypadType.GENERIC:
			return "Generic"
		_:
			return "Unknown"
