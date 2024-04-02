extends Node

const CHAR_FOLDER: String = "res://story/characters";

var Characters: Dictionary = {
	player = preload("uid://h58wg05sjss6")
};

func FillCharacters() -> void:
	var dir: DirAccess = DirAccess.open(CHAR_FOLDER);
	if (dir):
		for filename: String in dir.get_files():
			if(filename.get_extension() == "tres"):
				var id: String = filename.get_basename();
				if(Characters.has(id)):
					printerr("Character already exists. " + id);
					continue;
				var ch: GameCharacter = load(CHAR_FOLDER + "/" + filename);
				ch.index = id;
				Characters[id] = ch;
				var opt: GameRoomOption = GameRoomOption.new();
				opt.name = ch.name;
				opt.description = "Approach the " + ch.descriptionShort;
				opt.callback = "Dialogue";
				opt.callbackParams = [id, "0"];
				ch.dialogueOption = opt;

func _ready() -> void:
	FillCharacters();
