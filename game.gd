extends Node
class_name GameGlobalDirectory;

## Used for misc access to universal variables

const CHAR_FOLDER: String = "res://story/characters";
const DIALOGUE_FOLDER: String = "res://story/scenes/characters";
const DIALOGUE_FOLDER_FORMAT: String = "res://story/scenes/characters/{name}.gd";
const QUEST_FOLDER: String = "res://story/quests";
const QUEST_FOLDER_FORMAT: String = "res://story/quests/{name}.tres";

var Characters: Dictionary = {};
var Quests: Dictionary = {};

func _FillCharacters() -> void:
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
				ch.interactOption = opt;
				
				var acstr: String = DIALOGUE_FOLDER_FORMAT.format({"name":id});
				if(FileAccess.file_exists(acstr)):
					var dia: GDScript = load(acstr);
					ch.dialogue = dia.new();

func _FillQuests() -> void:
	var dir: DirAccess = DirAccess.open(QUEST_FOLDER);
	if (dir):
		for filename: String in dir.get_files():
			if(filename.get_extension() == "tres"):
				var id: String = filename.get_basename()
				if(Quests.has(id)):
					printerr("Quest already registered: " + id);
					continue;
				var q: GameQuest = load(QUEST_FOLDER_FORMAT.format({"name":id}));
				q.index = id;
				Quests[id] = q;
	return;

func _ready() -> void:
	_FillCharacters();
	_FillQuests();
