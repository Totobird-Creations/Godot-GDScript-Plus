tool
extends Object



var plugin              : EditorPlugin

var scene_trees         : Array
var create_dialogs      : Array
var create_dialog_trees : Array
var create_descriptions : Array

var scripts             : Dictionary # Key: Path to the script. Value: Script source.
var classes             : Dictionary # Key: Class name.         Value: Script source.



func _enter_tree() -> void:
	plugin.get_editor_interface().get_resource_filesystem().connect("filesystem_changed", self, "update_filesystem")


func _exit_tree() -> void:
	pass



func _ready() -> void:
	update_filesystem()
	find_all_create_descriptions()



func _process(delta : float) -> void:
	if (len(scene_trees) <= 0):
		find_all_scene_trees()
	if (len(scene_trees) > 0):
		parse_all_scene_trees()
	if (len(create_dialog_trees) <= 0):
		find_all_create_dialogs()
	if (len(create_dialog_trees) > 0):
		parse_all_create_trees()
	if (len(create_descriptions) <= 0):
		find_all_create_descriptions()
	if (len(create_descriptions) > 0):
		parse_all_create_descriptions()



func find_all_scene_trees() -> void:
	scene_trees = []
	for node in plugin.find_all_trees(plugin.get_tree().root, true, true):
		if (node.get_parent().get_class() == "SceneTreeEditor"):
			scene_trees.append(node)

func parse_all_scene_trees() -> void:
	for scene_tree in scene_trees:
		parse_scene_tree(scene_tree)

func parse_scene_tree(scene_tree : Tree) -> void:
	if (scene_tree.get_root()):
		parse_scene_tree_item(scene_tree.get_root())

func parse_scene_tree_item(item : TreeItem) -> void:
	var i := get_open_script_button_index(item)
	if (i != -1):
		var tooltip := item.get_button_tooltip(0, i)
		var prefix  := TranslationServer.translate("Open Script:") + " "
		var fname   := tooltip.trim_prefix(prefix)
		if (! scripts.has(fname)):
			try_load_script(fname)
		if (scripts.has(fname)):
			var flags := get_script_flags(scripts[fname])
			if ("tree_disable_script" in flags):
				item.set_button_disabled(0, i, true)
	var next := item.get_children()
	while (next):
		parse_scene_tree_item(next)
		next = next.get_next()

func get_open_script_button_index(item : TreeItem) -> int:
	for i in range(item.get_button_count(0)):
		var tooltip := item.get_button_tooltip(0, i)
		var prefix  := TranslationServer.translate("Open Script:") + " "
		if (tooltip.begins_with(prefix)):
			return i
	return -1



func find_all_create_dialogs() -> void:
	create_dialogs      = _find_all_create_dialogs()
	create_dialog_trees = []
	for create_dialog in create_dialogs:
		create_dialog_trees += plugin.find_all_trees(create_dialog, true, true)

func _find_all_create_dialogs(node : Node = plugin.get_tree().root) -> Array:
	var res := []
	if (node is AcceptDialog && node.get_class() == "CreateDialog" && node.get_parent().get_class() == "SceneTreeDock"):
		res.append(node)
	for child in node.get_children():
		res += _find_all_create_dialogs(child)
	return res

func parse_all_create_trees() -> void:
	for create_tree in create_dialog_trees:
		parse_create_tree(create_tree)

func parse_create_tree(create_tree : Tree) -> void:
	if (create_tree.get_root()):
		parse_create_tree_item(create_tree.get_root())

func parse_create_tree_item(item : TreeItem) -> void:
	var type := item.get_text(0).split(" (")[0]
	if (type in classes.keys()):
		var flags := get_script_flags(classes[type])
		var desc  := get_script_description(classes[type])
		if (desc != ""):
			item.set_tooltip(0, desc)
		if ("create_disable" in flags):
			item.set_selectable(0, false)
			item.set_custom_color(0, Color(1.0, 1.0, 1.0, 0.375))
		if ("create_hide_script" in flags):
			item.set_text(0, type)
	var next := item.get_children()
	while (next):
		parse_create_tree_item(next)
		next = next.get_next()



func find_all_create_descriptions() -> void:
	create_descriptions = []
	for dialog in create_dialogs:
		create_descriptions += plugin.find_all_editor_help_bits(dialog)

func parse_all_create_descriptions() -> void:
	var selected : TreeItem
	for tree in create_dialog_trees:
		selected = tree.get_selected()
		if (selected):
			var type        := selected.get_text(0).split(" (")[0]
			if (classes.has(type)):
				var description := get_script_description(classes[type])
				for help_bit in create_descriptions:
					help_bit.set_text("[b]" + type + "[/b]: " + description)
				break



func update_filesystem(path : String = "res:/") -> void:
	scripts = {}
	classes = {}
	var config := ConfigFile.new()
	config.load("res://project.godot")
	if (config.has_section("") && config.has_section_key("", "_global_script_classes")):
		for cls in config.get_value("", "_global_script_classes"):
			var rsr := try_load_script(cls.path)
			if (rsr):
				classes[cls.class] = rsr.source_code
	"""var dir := Directory.new()
	if (path == "res:/"):
		dir.open("res://")
	else:
		dir.open(path)
	dir.list_dir_begin(true, true)
	while (true):
		var fname := dir.get_next()
		var fpath := path + "/" + fname
		if (fname == ""):
			break
		elif (dir.dir_exists(fpath)):
			update_filesystem(fpath)
		elif (dir.file_exists(fpath) && fpath.get_extension() in ResourceLoader.get_recognized_extensions_for_type("GDScript")):
			var resource := ResourceLoader.load(fpath, "", false)
			if (resource is GDScript):
				var type := get_script_class_name(resource.source_code)
				if (type != ""):
					scripts[fpath] = resource.source_code
					classes[type] = resource.source_code
	dir.list_dir_end()"""

func try_load_script(path : String) -> Resource:
	var rsr := ResourceLoader.load(path)
	if (rsr is GDScript):
		scripts[path]  = rsr.source_code
		return rsr
	return null



func get_script_class_name(src : String) -> String:
	var regex := RegEx.new()
	regex.compile("(?:^|\n)class_name[ \t]+(.*)")
	var result := regex.search(src)
	if (result):
		return result.strings[1]
	return ""

func get_script_flags(src : String) -> Array:
	var flags := []
	var regex := RegEx.new()
	regex.compile("(?:^|\n)[ \t]*#@(.*)")
	var results := regex.search_all(src)
	for result in results:
		var flag : String = result.strings[1].strip_edges()
		if (! flags.has(flag)):
			flags.append(flag)
	return flags

func get_script_description(src : String) -> String:
	var description  := PoolStringArray()
	var regex_global := RegEx.new()
	regex_global.compile("((?:(?:^|\n)[ \t]*##(?:.*))+)\nclass_name")
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
