extends Node

var ignore_damage: bool
var time_scale: float:
	set(value):
		Engine.time_scale = value
		time_scale = value


func _ready() -> void:
	if OS.is_debug_build():
		ignore_damage = ProjectSettings.get_setting(&"application/run/ignore_damage", false)
		self.time_scale = ProjectSettings.get_setting(&"application/run/time_scale", 1.0)
		
		if not ProjectSettings.get_setting(&"application/run/first_play", true):
			ControllsGuide.skip()
		set_process_unhandled_input(
			ProjectSettings.get_setting(&"application/run/enable_screenshot", false)
		)
	else:
		set_process_unhandled_input(false)
		queue_free()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed(&"ui_copy"):
		take_screenshot()


func take_screenshot(): # Function for taking screenshots and saving them
	var date = Time.get_date_string_from_system().replace(".","_") 
	var time :String = Time.get_time_string_from_system().replace(":","")
	var screenshot_path = "user://" + "screenshot_" + date+ "_" + time + ".jpg" # the path for our screenshot.
	
	var image = get_viewport().get_texture().get_image() # We get what our player sees
	
	print_rich("[yellow]Screenshot saved %s[/yellow]" % screenshot_path)
	image.save_jpg(screenshot_path)
	OS.shell_open(OS.get_user_data_dir())
