extends Resource
class_name GameCharacter;

@export var name: String = "";
@export var textColor: Color = Color("#ebe5ff");
@export var gender: Enums.CharacterGender = Enums.CharacterGender.male;
@export var descriptionShort: String = "";
@export_multiline var description: String = "";
var index: String = ""; # Used by Game.Characters as a raw index via filename, incase name has spaces

var interactOption: GameRoomOption = null;
var dialogue: GameScene = null;
