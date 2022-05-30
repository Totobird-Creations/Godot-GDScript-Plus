extends EditorInspectorPlugin



const SCANNER : Script = preload("./scanner.gd")



func can_handle(object : Object) -> bool:
	return true


func parse_property(object : Object, type : int, path : String, hint : int, hint_text : String, usage : int) -> bool:
	if (object.get_script()):
		var src         : String = object.get_script().source_code
		var description :        = ""
		var allow_pass  :        = false

		# If the object has this method, the return value overrides the comments.
		if (object.has_method("get_property_description")):
			var desc = object.get_property_description(path)
			if (desc is String && desc != ""):
				description = desc
				allow_pass = true

		# If the method failed, regex search for doublehash comments.
		if (! allow_pass):
			var regex_global := RegEx.new()
			regex_global.compile("((?:(?:^|\n)[ \t]*##(?:.*))+)\nexport *(?:\\(.*\\))?[ \t]*var[ \t]*(?:" + path + ")(?: |\t|\n|=|;)")
			var result_global := regex_global.search(src)
			if (result_global):
				allow_pass = true

				# A doublehash comment group was found. Parse it into lines, then combine them into one string.
				var lines : PoolStringArray = result_global.strings[1].split("\n")
				for line in lines:

					var regex_line := RegEx.new()
					regex_line.compile("(?:^|\n)[ \t]*##(.*)")
					var result_line := regex_line.search(line)
					if (result_line):
						var desc_line : String = result_line.strings[1].replace("\n", "").strip_edges(false, true).trim_prefix(" ")
						if (desc_line == ""):
							if (len(description) == 0 || description[-1] != "\n"):
								description += "\n"
						else:
							description += " " + desc_line

		# If a description was found, inject a tooltip scanner into the inspector.
		if (allow_pass):
			var instance := SCANNER.new()
			instance.object      = object
			instance.path        = path
			instance.description = description.strip_edges(false, true).trim_prefix(" ")
			add_property_editor(path, instance)

	return false
