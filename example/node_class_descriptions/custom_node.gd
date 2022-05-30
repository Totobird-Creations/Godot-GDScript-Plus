extends MyCustomUncreatableNode
## This one is separated from the class_name so it won't show up

## This is my custom node that I made all by myself!
## Wow! How amazing!
class_name MyCustomNode

# The line below disables the open script button in the scene tree.
#@ tree_disable_script



func _ready() -> void:
	print("This node does have a script.")
