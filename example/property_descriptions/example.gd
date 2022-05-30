tool
extends Node

#@tree_disable_script



## This is a signal description.
## More description.
signal custom_signal(arg_0, arg_1)



enum NamedEnum {THING_1, THING_2, ANOTHER_THING = -1}

## An integer without the export arguments.
export                                               var object = 0
## An unrestricted integer.
export(int)                                          var number
## An integer that allows values from 0 to 20 (inclusive).
export(int, 20)                                      var i;
## An integer that allows values from -10 to 20 (inclusive).
export(int, -10, 20)                                 var j;
## This is an integer enum.
export(int, "Warrior", "Magician", "Thief")          var character_class;
## This is an integer enum, generated from an enum.
export(NamedEnum)                                    var x
## This is an integer bit flag.
export(int, FLAGS, "Fire", "Water", "Earth", "Wind") var spell_elements = 0
## This is an integer bit flag.
export(int, LAYERS_2D_PHYSICS)                       var layers_2d_physics
## This is an integer bit flag.
export(int, LAYERS_2D_RENDER)                        var layers_2d_render
## This is an integer bit flag.
export(int, LAYERS_3D_PHYSICS)                       var layers_3d_physics
# This is an integer bit flag that doesn't show a description.
export(int, LAYERS_3D_RENDER)                        var layers_3d_render

## A float that allows values from -10 to 20 (inclusive), while snapping to multiples of 0.2.
export(float, -10, 20, 0.2)                          var k
## Allow values 'y = exp(x)' where 'y' varies between 100 and 1000
## while snapping to steps of 20. The editor will present a
## slider for easily editing the value.
## All of these lines are picked up by the scanner.
export(float, EXP, 100, 1000, 20)                    var l
# Display a visual representation of the 'ease()' function.
export(float, EASE)                                  var transition_speed

## This is a vector2.
export(Vector2)                                      var vec2
## This is a vector3.
export(Vector3)                                      var vec3
## This is a quat.
export(Quat)                                         var quat

## This is a string.
export(String)                                       var string
## This is a string enum.
export(String, "Rebecca", "Mary", "Leah")            var character_name
## A string path to a file in this project.
export(String, FILE)                                 var f
## A string path to a directory in this project.
export(String, DIR)                                  var g
## A string path to a file in this project, with filter `*.txt`.
export(String, FILE, "*.txt")                        var h
## A string path to a file in the global filesystem, with filter `*.png`.
export(String, FILE, GLOBAL, "*.png")                var tool_image
## A string path to a directory in the global filesystem.
export(String, DIR, GLOBAL)                          var tool_dir
## This is a string with a large input field that allows multiline editing.
export(String, MULTILINE)                            var text

## This is a colour, where alpha is always 1.0.
export(Color, RGB)                                   var col_rgb
## This is a colour with alpha.
export(Color, RGBA)                                  var col_rgba

## This is a path to another node in the scene.
export(NodePath)                                     var node_path

## This is a resource.
export(Resource)                                     var resource
## This is an animationnode resource.
export(AnimationNode)                                var specific_resource
## This is a texture resource.
export(Texture)                                      var character_face

# This line isn't picked up because it doesn't start with ##
## This is a packedscene object.
export(PackedScene)                                  var scene_file

## This is an unrestricted array.
export(Array)                                        var a
## This is an integer array.
export(Array, int)                                   var ints
## This is an integer enum array.
export(Array, int, "Red", "Green", "Blue")           var enums
## This is an float array array.
export(Array, Array, float)                          var two_dimensional

## This is a poolbytearray.
export(PoolByteArray)                                var pool_byte
## This is a poolvector3array and this label has
## [b]fancy[/b]
## 
## [u]formatting[/u]
## :)
export(PoolVector3Array)                             var pool_vector3

## This is an unrestricted dictionary.
export(Dictionary)                                   var dictionary



# Return values inside of this function override commends.
func get_property_description(property : String) -> String:
	if (property == "dictionary"):
		return "The get_property_description method overwrote the dictionary description."
	return ""
