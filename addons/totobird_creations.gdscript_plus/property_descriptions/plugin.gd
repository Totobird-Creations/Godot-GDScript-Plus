tool
extends Object



var plugin      : EditorPlugin

var inspector   : Control

var properties  : Array



func _process(_delta : float) -> void:
	if (! inspector):
		inspector = plugin.get_editor_interface().get_inspector().get_child(0)
	if (inspector):
		parse_all_properties(inspector)



func parse_all_properties(node : Node) -> void:
	if (node is EditorProperty):
		if (node.get_edited_object().script is GDScript):
			var property    : String = node.get_edited_property()
			var text_edited : bool   = false
			var text        : String = TranslationServer.translate("Property:") + " [b][u]" + property + "[/u][/b]"
			var description : String = ""
			if (node.get_edited_object().has_method("get_property_variable")):
				var v = node.get_edited_object().get_property_variable(property)
				if (v is String && v != ""):
					text_edited = true
					text        = TranslationServer.translate("Property:") + " [b][u]" + v + "[/u][/b]"
			if (node.get_edited_object().has_method("get_property_description")):
				var v = node.get_edited_object().get_property_description(property)
				if (v is String && v != ""):
					description = v
			if (description == ""):
				var src     : String = node.get_edited_object().script.source_code
				description          = get_property_description(src, property)
			if (description != ""):
				text_edited  = true
				text        += "\n" + description
			if (text_edited):
				var help_bits : Array = plugin.find_all_editor_help_bits(node)
				if (len(help_bits) > 0):
					var help_bit : Control = help_bits[0]
					help_bit.set_text(text)
					help_bit.get_child(0).fit_content_height = true
	for child in node.get_children():
		parse_all_properties(child)



func get_property_description(src : String, property : String) -> String:
	var description  := PoolStringArray()
	var regex_global := RegEx.new()
	regex_global.compile("((?:(?:^|\n)[ \t]*##(?:.*))+)\nexport *(?:\\(.*\\))?[ \t]*var[ \t]*(?:" + property + ")(?: |\t|\n|=|;)")
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
