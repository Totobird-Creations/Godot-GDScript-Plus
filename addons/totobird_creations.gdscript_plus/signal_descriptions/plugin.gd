tool
extends Object



var plugin           : EditorPlugin

var connection_trees : Array
var signals          : Dictionary
var fname            : String



func _process(delta : float) -> void:
	if (len(connection_trees) <= 0):
		find_all_connections()
	if (len(connection_trees) > 0):
		find_fname()
		parse_all_connection_trees()



func find_all_connections() -> void:
	connection_trees = []
	var docks := _find_all_connection_docks()
	for dock in docks:
		connection_trees += plugin.find_all_trees(dock, true, false)

func _find_all_connection_docks(node : Node = plugin.get_tree().root) -> Array:
	var res := []
	if (node.get_class() == "ConnectionsDock"):
		res.append(node)
	for child in node.get_children():
		res += _find_all_connection_docks(child)
	return res

func find_fname() -> void:
	fname = ""
	var node_classes : Object = plugin.sub_plugins.node_classes
	if (len(node_classes.scene_trees) > 0):
		var node : TreeItem = node_classes.scene_trees[0].get_selected()
		if (node):
			var i : int = node_classes.get_open_script_button_index(node)
			if (i != -1):
				var tooltip     := node.get_button_tooltip(0, i)
				var prefix      := TranslationServer.translate("Open Script:") + " "
				fname            = tooltip.trim_prefix(prefix)

func parse_all_connection_trees() -> void:
	for connection_tree in connection_trees:
		parse_connection_tree(connection_tree)

func parse_connection_tree(connection_tree : Tree) -> void:
	if (connection_tree.get_root()):
		parse_connection_tree_item(connection_tree.get_root())
	var help_bits : Array = plugin.find_all_editor_help_bits(connection_tree, true, false)
	if (len(help_bits) > 0):
		var help_bit : Control = help_bits[0]
		if (! help_bit.has_meta("injected_signal_description")):
			help_bit.set_meta("injected_signal_description", true)
			var parts   : PoolStringArray = help_bit.get_child(0).text.trim_prefix(TranslationServer.translate("Signal:") + " ").split("(")
			var signame : String          = parts[0]
			if (signame in signals.keys()):
				parts.remove(0)
				var args        : String = "(" + parts.join("(")
				var description : String = signals[signame]
				help_bit.set_text(TranslationServer.translate("Signal:") + " [b][u]" + signame + "[/u][/b]" + args + "\n" + description)
				help_bit.get_child(0).fit_content_height = true

func parse_connection_tree_item(item : TreeItem) -> void:
	if (fname != ""):
		var signame     := item.get_text(0).split("(")[0]
		var description := get_signal_description(plugin.sub_plugins.node_classes.scripts[fname], signame)
		if (description != ""):
			signals[signame] = description
	var next := item.get_children()
	while (next):
		parse_connection_tree_item(next)
		next = next.get_next()



func get_signal_description(src : String, signame : String) -> String:
	var description  := PoolStringArray()
	var regex_global := RegEx.new()
	regex_global.compile("((?:(?:^|\n)[ \t]*##(?:.*))+)\nsignal[ \t]*(?:" + signame + ")(\\(.*\\))?(?: |\t|\n|=|;)")
	var result_global := regex_global.search(src)
	if (result_global):
		var lines : PoolStringArray = result_global.strings[1].split("\n")
		for line in lines:
			var regex_line := RegEx.new()
			regex_line.compile("(?:^|\n)[ \t]*##(.*)")
			var result_line := regex_line.search(line)
			if (result_line):
				var desc_line : String = result_line.strings[1].strip_edges(false, true).trim_prefix(" ")
				description.append(desc_line)
	return description.join(" ")
