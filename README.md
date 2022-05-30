# GDScript Plus
![icon](https://raw.githubusercontent.com/Totobird-Creations/Godot-GDScript-Plus/main/images/icon.png)
An addon for Godot 3.4, written completely in GDScript, that gives GDScript some extra functionality.

### Features
- Custom nodes can disable the script button in the scene tree.
- Custom nodes can disable creation using the create node menu.
- Custom nodes can hide the script filename shown in the create node menu.
- Export properties on nodes can have tooltips and descriptions.

### Installation

__Method 1__:
- Open the AssetLib tab in Godot.
- Search for `GDScript Plus`.
- Download and install the plugin by `Totobird Creations` (If it isn't there, you will have to use method 2).
- Open your project settings and go to the `Plugins` tab.
- Enable the `GDScript Plus` plugin.
- You're done!

__Method 2__:
- Download or clone this repository.
- Move the `addons/totobird_creations.property_descriptions` folder into the `addons` folder in your project.
- Open your project settings and go to the `Plugins` tab.
- Enable the `GDScript Plus` plugin.
- You're done!

### Usage

__Property Descriptions__:

In a GDScript file, on a line directly before an `export` command, add a line starting with `##`. You can have as many lines as you want, as long as there is no separation between them<br />
Example:
```gdscript
## Hit points of the player.
## This should not be set below 0.
export(int) var hit_points := 10
```
```gdscript
## This will not be a description because there is an empty line below.

export(String) var player_name := "Player"
```
Alternatively, you can define a `get_property_description` method in the script. This is useful for when you override the `_get_property_list` method. If the `get_property_description` method is defined, and it doesn't return an empty string, the doublehash comment will be ignored.
```gdscript
func get_property_description(property : String) -> String:
	if (property == "player_strength"):
		return "How much damage the player deals."
	return "" # If the return value is empty, no description will be provided.
```

__Node Class Descriptions__:

In a GDScript file, on a line directly before the `class_name` command, add a line starting with `##`. You can have as many lines as you want, as long as there is no separation between them<br />
Example:
```gdscript
## Generic entity class.
## Contains information about hitpoints, attack damage, etc.
class_name Entity
```
```gdscript
## This will not be a description because there is an empty line below.

class_name PlayerEntity
```

__Node Class Tags__:

In a GDScript file, You can include lines starting with `#@`, and followed by an identifier to change how to custom class acts in the editor<br />
- `tree_disable_script` : Disables the open script button in the scene tree.
- `create_disable` : Similar to the `CanvasItem` node, this will prevent the node from being created using the create node menu. It can still be used by manually applying the script.
- `create_hide_script` : In the create node menu, the script filename will not be displayed.
Example:
```gdscript
#@ tree_disable_script
#@create_hide_script
# There can be a space between the prefix and tag.
```

### License
MIT
