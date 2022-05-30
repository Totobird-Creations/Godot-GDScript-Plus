tool
extends EditorPlugin



var sub_plugins : Dictionary = {
	node_classes          = preload('./node_classes/plugin.gd').new(),
	property_descriptions = preload('./property_descriptions/plugin.gd').new(),
	signal_descriptions   = preload('./signal_descriptions/plugin.gd').new()
}



func _enter_tree() -> void:
	if (Engine.is_editor_hint()):
		for plugin in sub_plugins.values():
			plugin.plugin = self
			if (plugin.has_method("_enter_tree")):
				plugin._enter_tree()

func _exit_tree() -> void:
	if (Engine.is_editor_hint()):
		for plugin in sub_plugins.values():
			if (plugin.has_method("_exit_tree")):
				plugin._exit_tree()



func _ready() -> void:
	if (Engine.is_editor_hint()):
		for plugin in sub_plugins.values():
			if (plugin.has_method("_ready")):
				plugin._ready()



func _process(delta : float) -> void:
	if (Engine.is_editor_hint()):
		for plugin in sub_plugins.values():
			if (plugin.has_method("_process")):
				plugin._process(delta)



func find_all_editor_help_bits(node : Node, dive : bool = true, dive_past : bool = true) -> Array:
	var res := []
	if (node.get_class() == "EditorHelpBit"):
		res.append(node)
	if (dive):
		for child in node.get_children():
			res += find_all_editor_help_bits(child, dive_past, dive_past)
	return res

func find_all_trees(node : Node, dive : bool = true, dive_past : bool = true) -> Array:
	var res := []
	if (node is Tree):
		res.append(node)
	if (dive):
		for child in node.get_children():
			res += find_all_trees(child, dive_past, dive_past)
	return res
