class_name ReplicaData

var speaker_name: String
var text: String

func _init(source: Dictionary):
	speaker_name = source["speaker_name"] if source.has("speaker_name") else ""
	text = source["text"]
