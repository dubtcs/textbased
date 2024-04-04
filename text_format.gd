extends Node

const CHAR_HEADER: String = "[color={char_color}]{char_name}[/color]";
const CHAR_SPEECH_TEXT: String = "{char_header}: {msg}";
const CHAR_DESC_TEXT: String = "{char_header} {msg}";

## HOW TO USE
## Format character interactions and speech with CharacterMulti()
## Example:
## Meatball rolls around on the floor. He says, "Hello, Player"
## {meatball} rolls around on the floor. {meatball_ref} says, "Hello, {player}"

## TODO: Add a way to force a capital letter using {character_ref} format
## Probs just gonna need a custom formatting function

var _charPrefixes: Dictionary = {};

func CharacterMulti(msg: String) -> String:
	return msg.format(_charPrefixes);

func _FormatCharacterBase(character: GameCharacter, msg: String) -> String:
	var header: String = CHAR_HEADER.format({"char_color":character.textColor.to_html(true), "char_name":character.name});
	return msg.format({"char_header":header});

func _FormatCharacterHeader(character: GameCharacter) -> String:
	return CHAR_HEADER.format({"char_color":character.textColor.to_html(true), "char_name":character.name});

func LoadCharacterPrefixes() -> void:
	for char: GameCharacter in Game.Characters.values():
		_charPrefixes[char.index] = _FormatCharacterHeader(char);
		match(char.gender):
			Enums.CharacterGender.neutral:
				_charPrefixes[char.index+"_ref"] = "they";
			Enums.CharacterGender.male:
				_charPrefixes[char.index+"_ref"] = "he";
			Enums.CharacterGender.female:
				_charPrefixes[char.index+"_ref"] = "she";

func CharacterSpeech(character: GameCharacter, msg: String) -> String:
	return _FormatCharacterBase(character, CHAR_SPEECH_TEXT).format({"msg":msg,"char_name":character.name});

func CharacterDescriptor(character: GameCharacter, msg: String) -> String:
	return _FormatCharacterBase(character, CHAR_DESC_TEXT).format({"msg":msg,"char_name":character.name});
