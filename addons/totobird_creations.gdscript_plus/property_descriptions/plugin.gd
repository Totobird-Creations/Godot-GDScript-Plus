tool
extends Object



var plugin    : EditorPlugin

var inspector : EditorInspectorPlugin = preload("./inspector.gd").new()



func _enter_tree() -> void:
	plugin.add_inspector_plugin(inspector)

func _exit_tree() -> void:
	plugin.remove_inspector_plugin(inspector)
