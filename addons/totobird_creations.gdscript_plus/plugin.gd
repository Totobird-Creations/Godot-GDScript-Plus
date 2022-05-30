tool
extends EditorPlugin



var sub_plugins : Array = [
	preload('./node_classes/plugin.gd').new(),
	preload('./property_descriptions/plugin.gd').new()
]



func _enter_tree() -> void:
	if (Engine.is_editor_hint()):
		for plugin in sub_plugins:
			plugin.plugin = self
			if (plugin.has_method("_enter_tree")):
				plugin._enter_tree()

func _exit_tree() -> void:
	if (Engine.is_editor_hint()):
		for plugin in sub_plugins:
			if (plugin.has_method("_exit_tree")):
				plugin._exit_tree()



func _ready() -> void:
	if (Engine.is_editor_hint()):
		for plugin in sub_plugins:
			if (plugin.has_method("_ready")):
				plugin._ready()



func _process(delta : float) -> void:
	if (Engine.is_editor_hint()):
		for plugin in sub_plugins:
			if (plugin.has_method("_process")):
				plugin._process(delta)
