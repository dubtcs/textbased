extends Node

const CHAR_HEADER: String = "[color={char_color}]{char_name}[/color]";
const CHAR_SPEECH_TEXT: String = "{char_header}: {msg}";
const CHAR_DESC_TEXT: String = "{char_header} {msg}";

func CharacterSpeech(character: GameCharacter, msg: String) -> String:
	return _FormatCharacterBase(character, CHAR_SPEECH_TEXT).format({"msg":msg});

func CharacterDescriptor(character: GameCharacter, msg: String) -> String:
	return _FormatCharacterBase(character, CHAR_DESC_TEXT).format({"msg":msg});

func _FormatCharacterBase(character: GameCharacter, msg: String) -> String:
	var header: String = CHAR_HEADER.format({"char_color":character.textColor.to_html(true), "char_name":character.name});
	return msg.format({"char_header":header});
