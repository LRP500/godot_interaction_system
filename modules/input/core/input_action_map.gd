extends Resource
class_name InputActionMap

@export var id: String
@export var events: Array[InputActionMapEvent]
@export var enable_mouse_motion: bool

func process() -> void:
	for event in events:
		event.process()

func get_key_event(event_name: String) -> InputActionMapKeyEvent:
	for event in events:
		if event.event_name == event_name:
			assert(event is InputActionMapKeyEvent, 
				"[Input] Invalid action map event type ([i]%s[/i])" % event_name)
			return event
	return null

func has_event(event_name: String) -> bool:
	return get_key_event(event_name) != null