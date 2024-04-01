extends Node

const CHAR_SPEECH_TEXT: String = "[color={char_color}]{char_name}[/color]: {char_msg}";

func CharacterSpeech(character: GameCharacter, msg: String) -> String:
	return CHAR_SPEECH_TEXT.format({"char_color" : character.textColor.to_html(true), "char_name" : character.name, "char_msg" : msg});
