extends Panel
class_name GameQuestContainer;

func UdpateQuests(quests: PlayerQuestManager) -> void:
	for index in quests._quests:
		print(index);
