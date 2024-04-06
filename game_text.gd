extends Node

## Format()
## Formatting: {[modifier]character_name}
## The case of the first letter of character_name will determine if the replacement is capitalized
## Modifiers (optional):
## 	@ : Subject
##  # : Object
##  $ : Possesive
##  % : Contraction

## EXAMPLE
## Person: Male
## {Person} waves goodbye. {@Person} walks away. {$Person} shoes are on backwards. {%person} gonna laugh.
## Person waves goodbye. He walks away. His shoes are on backwards. he's gonna laugh.
## NOTE: The final {%person} is a lowercase "person", this makes the replacement follow suit

## FormatO()
## Formatting: {character_name,[masculine/feminine/neutral]}
## The case of the first letter of character_name will determine if the replacement is capitalized
## The array is optional

## EXAMPLE
## Person: Male
## {Person} waves goodbye. {Person,he walks/she walks/they walk} away. {Person,his/her/their} shoes are on backwards. {person,he's,she's,they're} gonna laugh.
## Person waves goodbye. He walks away. His shoes are on backwards. he's gonna laugh.
## NOTE: The final {person} is a lowercase "person", this makes the replacement follow suit

const CHAR_HEADER: String = "[color={char_color}]{char_name}[/color]";
const CHAR_SPEECH_TEXT: String = "{char_header}: {msg}";
const CHAR_DESC_TEXT: String = "{char_header} {msg}";

const FORMAT_ENTRY: String = "{";
const FORMAT_EXIT: String = "}";
const FORMAT_SEP: String = ",";
const FORMAT_OPTION_SEP: String = "/";
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

func FormatO(msg: String) -> String:
	var i: int = 0;
	var s: String = "";
	var keyIndex: int = 0;
	var startIndex: int = 0;
	var formatting: bool = false;
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
						s += CHAR_HEADER.format({"char_color":character.textColor.to_html(true), "char_name":replacement});
		else:
			if(ch == FORMAT_ENTRY):
				formatting = true;
				startIndex = i + 1;
				keyIndex = startIndex;
			else:
				s += ch;
		i += 1;
	if(formatting):
		printerr("Incomplete format entry: " + msg);
		s += msg.substr(startIndex - 1, msg.length() - 3);		
	return s;

func Format(msg: String) -> String:
	var index: int = 0;
	var s: String = "";
	var ref: bool = false;
	var refState: int = 0;
	var startIndex: int = 0;
	var formatting: bool = false;
	for ch: String in msg:
		if(formatting):
			if(index == startIndex):
				if(ch == FORMAT_SUB):
					ref = true;
				elif(ch == FORMAT_OBJ):
					ref = true;
					refState = 1;
				elif(ch == FORMAT_POS):
					ref = true;
					refState = 2;
				elif(ch == FORMAT_CON):
					ref = true;
					refState = 3;
			elif(ch == FORMAT_EXIT):
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
			if(ch == FORMAT_ENTRY):
				formatting = true;
				startIndex = index + 1
			else:
				s += ch;
		index += 1;
	if(formatting):
		s += msg.substr(startIndex - 1, msg.length() - 3);
		printerr("No delimiter for formatted string. \"" + msg + "\"");
	return s;
