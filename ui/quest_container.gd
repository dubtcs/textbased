extends Panel
class_name GameQuestContainer;

var stepScene: PackedScene = preload("res://ui/gameplay/quest_panel.tscn");

@onready var container: VBoxContainer = $"ScrollContainer/VBoxContainer";

func FillQuests(quests: PlayerQuestManager) -> void:
	for index: String in quests._quests:
		var cur: GamePlayerQuest = quests.Get(index);
		var but: QuestPanel = stepScene.instantiate();
		container.add_child(but);
		but.name = index;
		but.SetQuest(cur.instance);
		but.UpdateSteps(cur);
		
func UpdateQuests(quests: Array[GamePlayerQuest]) -> void:
	for q: GamePlayerQuest in quests:
		var node: QuestPanel = container.get_node(q.index);
		if(node):
			node.UpdateSteps(q);
