extends EditorProperty



var object      : Object
var path        : String
var description : String
var target      : EditorProperty



func _init() -> void:
	visible = false



func _process(_delta : float) -> void:
	# If it hasn't found the real editor, check if it exists.
	if (! target is EditorProperty):
		var tg := get_parent().get_child(get_index() + 1)
		if (tg is EditorProperty && tg.get_edited_object() == object && tg.get_edited_property() == path):
			target = tg

	# If it has found the real editor, look for tooltips.
	if (target is EditorProperty):
		for child in target.get_children():
			# If it finds a tooltip, inject the description into the bbcode.
			if (child.get_class() == "EditorHelpBit" && ! child.has_meta("injected_gdscript_tooltip")):
				child.set_meta("injected_gdscript_tooltip", true)
				child.set_text(TranslationServer.translate("Property:") + " [b][u]" + path + "[/u][/b]\n" + description)
				child.get_child(0).fit_content_height = true
