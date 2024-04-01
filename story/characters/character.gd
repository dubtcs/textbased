extends Resource
class_name GameCharacter;

@export var name: String = "";
@export var textColor: Color = Color("#ebe5ff");
var index: String = ""; # Used by Game.Characters as a raw index via filename, incase name has spaces
