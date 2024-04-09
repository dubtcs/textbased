extends Node

## Format()
## Use {} for referencing characters. Use <> for character dialogue.
## {} Will follow capitalization of the supplied name for pronouns. Useful for start of sentences.

## {character_name,(male/female/neutral)}
## <character_name>dialogue</character_name>

## EXAMPLE
## Person: Male
## Meatball: Male

## INPUT: {Person} waves goodbye. {person,he walks/she walks/they walk} away.
## OUTPUT: Person waves goodbye. he walks away. <- NOTE: Capitalization of character_name effects pronoun replacement

## INPUT: <person>WHAT! {Meatball,he's/she's/they're} gonna be mad.</person>
## OUTPUT: Person: "WHAT! He's gonna be mad."

const CHAR_HEADER: String = "[color={char_color}]{char_name}[/color]";
const CHAR_SPEECH_TEXT: String = "{char_header}: {msg}";
const CHAR_DESC_TEXT: String = "{char_header} {msg}";

const FORMAT_ENTRY: String = "{";
const FORMAT_EXIT: String = "}";
const FORMAT_SEP: String = ",";
const FORMAT_OPTION_SEP: String = "/";
const FORMAT_COL_ENTRY: String = "<";
const FORMAT_COL_EXIT: String = ">";

func Format(msg: String) -> String:
	var i: int = 0;
	var s: String = "";
	var keyIndex: int = 0;
	var startIndex: int = 0;
	var formatting: bool = false;
	var coloring: int = 0;
	for ch: String in msg:
		if(formatting):
			if(ch == FORMAT_SEP):
				keyIndex = i - 1;
			elif(ch == FORMAT_EXIT):
				formatting = false;
				var length: int = i - startIndex if keyIndex == startIndex else (keyIndex - startIndex) + 1;
				var key: String = msg.substr(startIndex, length);
				var options: PackedStringArray = msg.substr(keyIndex + 2, (i - keyIndex) - 2).split(FORMAT_OPTION_SEP);
				if(Game.Characters.has(key.to_lower())):
					var character: GameCharacter = Game.Characters[key.to_lower()];
					if(options.size() < 3):
						s += CHAR_HEADER.format({"char_color":character.textColor.to_html(true), "char_name":character.name});
					else:
						var replacement: String = options[character.gender];
						if(key[0] == key[0].to_upper()):
							replacement[0] = replacement[0].to_upper();
						s += replacement;
		elif(coloring):
			if(ch == FORMAT_OPTION_SEP):
				coloring = 2;
			if(ch == FORMAT_COL_EXIT):
				if(coloring == 1):
					var key: String = msg.substr(startIndex, i - startIndex);
					if(Game.Characters.has(key.to_lower())):
						var character: GameCharacter = Game.Characters.get(key.to_lower());
						s += "[b]{char_name}[/b]: ".format({"char_name":character.name});
						s += "[color={c}]\"".format({"c":character.textColor.to_html(true)});
					else:
						printerr("No character found: " + key);
						s += msg.substr(startIndex - 1, (i - startIndex) + 2);
				else:
					s += "\"[/color]";
				coloring = 0;
		else:
			if(ch == FORMAT_ENTRY):
				formatting = true;
				startIndex = i + 1;
				keyIndex = startIndex;
			elif(ch == FORMAT_COL_ENTRY):
				coloring = 1;
				startIndex = i + 1;
			else:
				s += ch;
		i += 1;
	if(formatting):
		printerr("Incomplete format entry: " + msg);
		s += msg.substr(startIndex - 1, msg.length() - 3);		
	return s;
