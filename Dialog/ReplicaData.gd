class_name ReplicaData

enum SpeakerLocation { LEFT, RIGHT }

var speaker_location: SpeakerLocation
var speaker_name: String
var text: String

func _init(source: Dictionary):
	speaker_location = SpeakerLocation.get(source["speaker_location"])
	speaker_name = source["speaker_name"]
	text = source["text"]
