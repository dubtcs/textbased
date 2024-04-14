extends Resource
class_name GamePlayer;

signal quest_progress(index: String);

var _inventory: PlayerInventory = PlayerInventory.new();
var _quests: PlayerQuestManager = PlayerQuestManager.new();
var _flags: PlayerFlagManager = PlayerFlagManager.new();

func Flags() -> PlayerFlagManager:
	return _flags;
	
func Quests() -> PlayerQuestManager:
	return _quests;
	
func Inventory() -> PlayerInventory:
	return _inventory;

func CheckQuest(questName: String) -> Enums.QuestStatus:
	if(_quests.has(questName)):
		return _quests.get(questName).status;
	return Enums.QuestStatus.available;

func GetItem(itemName: String) -> GameItem:
	if(_inventory.has(itemName)):
		return _inventory.get(itemName).instance;
	return null;

func HasItem(itemName: String) -> bool:
	return _inventory.has(itemName);
	
func CheckFlag(index: String) -> bool:
	return _flags.Check(index);
	
func SetFlag(index: String) -> void:
	_flags.Set(index);
	var rv: Array[GamePlayerQuest] = _quests.UpdateFlagQuests(_flags);
	if(not rv.is_empty()):
		quest_progress.emit(rv);
	return;
	
func RemoveFlag(index: String) -> void:
	return _flags.Remove(index);
