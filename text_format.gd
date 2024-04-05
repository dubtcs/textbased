extends Node

## HOW TO USE
## Format character interactions and speech with CharacterMulti()
## Formatting: { [modifier] character_name }
## The case of the first letter of character_name will determine if the replacement is capitalized
## Modifiers:
## 	@ : Subject
##  # : Object
##  $ : Possesive
##  % : Contraction

## EXAMPLE
## Person: Male
## {Person} waves goodbye. {@Person} walks away. {$Person} shoes are on backwards. {%person} gonna laugh.
## Person waves goodbye. He walks away. His shoes are on backwards. he's gonna laugh.
## NOTICE: The final {%person} is a lowercase "person", this makes the replacement follow suit

const CHAR_HEADER: String = "[color={char_color}]{char_name}[/color]";
const CHAR_SPEECH_TEXT: String = "{char_header}: {msg}";
const CHAR_DESC_TEXT: String = "{char_header} {msg}";

const FORMAT_ENTRY: String = "{";
const FORMAT_EXIT: String = "}";
const FORMAT_SUB: String = "@"; ## Subject
const FORMAT_OBJ: String = "#"; ## Object
const FORMAT_POS: String = "$"; ## Possessive
const FORMAT_CON: String = "%"; ## Contraction

const SUB_GENDER_NEUTRAL: String = "they";
const SUB_GENDER_MALE: String = "he";
const SUB_GENDER_FEMALE: String = "she";

const OBJ_GENDER_NEUTRAL: String = "them";
const OBJ_GENDER_MALE: String = "him";
const OBJ_GENDER_FEMALE: String = "her";

const POS_GENDER_NEUTRAL: String = "their";
const POS_GENDER_MALE: String = "his";
const POS_GENDER_FEMALE: String = "hers";

const CON_GENDER_NEUTRAL: String = "they're";
const CON_GENDER_MALE: String = "he's";
const CON_GENDER_FEMALE: String = "she's";

const _refmap: Dictionary = {
	Enums.CharacterGender.neutral 	: [ SUB_GENDER_NEUTRAL, OBJ_GENDER_NEUTRAL, POS_GENDER_NEUTRAL, CON_GENDER_NEUTRAL ],
	Enums.CharacterGender.male		: [ SUB_GENDER_MALE   , OBJ_GENDER_MALE   , POS_GENDER_MALE   , CON_GENDER_MALE    ],
	Enums.CharacterGender.female 	: [ SUB_GENDER_FEMALE , OBJ_GENDER_FEMALE , POS_GENDER_FEMALE , CON_GENDER_FEMALE  ]
};

var _charPrefixes: Dictionary = {};

## @tutorial: bruh
func CharacterMulti(msg: String) -> String:
	var index: int = 0;
	var s: String = "";
	var ref: bool = false;
	var refState: int = 0;
	var startIndex: int = 0;
	var formatting: bool = false;
	for char: String in msg:
		if(formatting):
			if(index == startIndex):
				if(char == FORMAT_SUB):
					ref = true;
				elif(char == FORMAT_OBJ):
					ref = true;
					refState = 1;
				elif(char == FORMAT_POS):
					ref = true;
					refState = 2;
				elif(char == FORMAT_CON):
					ref = true;
					refState = 3;
			elif(char == FORMAT_EXIT):
				formatting = false;
				var key: String = msg.substr(startIndex + int(ref), (index - startIndex) - int(ref));
				if(Game.Characters.has(key.to_lower())):
					var character: GameCharacter = Game.Characters[key.to_lower()];
					var replacement: String = character.name;
					if(ref):
						replacement = _refmap[character.gender][refState];
					if(key[0] == key.to_upper()[0]):
						replacement[0] = replacement[0].to_upper();
					replacement = CHAR_HEADER.format({"char_color":character.textColor.to_html(true), "char_name":replacement});
					s += replacement;
				else:
					s += msg.substr(startIndex - 1, (index - startIndex) + 2);
				ref = false;
		else:
			if(char == FORMAT_ENTRY):
				formatting = true;
				startIndex = index + 1
			else:
				s += char;
		index += 1;
	if(formatting):
		s += msg.substr(startIndex - 1, msg.length() - 3);
		printerr("No delimiter for formatted string. \"" + msg + "\"");
	return s;
