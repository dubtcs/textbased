extends Panel
class_name GameQuestContainer;

var stepLabel: PackedScene = preload("uid://8jpum80fo1v6");

@onready var container: VBoxContainer = $"HBoxContainer/ScrollContainer/VBoxContainer";
@onready var titleLabel: Label = $"HBoxContainer/Panel/VBoxContainer/TitleName";
@onready var descriptionLabel: Label = $"HBoxContainer/Panel/VBoxContainer/HBoxContainer/Desc/VBoxContainer/Description";
@onready var stepsContainer: VBoxContainer = $"HBoxContainer/Panel/VBoxContainer/VBoxContainer/ScrollContainer/VBoxContainer";

func FillQuests(quests: PlayerQuestManager) -> void:
	for index: String in quests._quests:
		var cur: GamePlayerQuest = quests.Get(index);
		var but: Button = Button.new();
		but.name = index;
		but.text = cur.instance.name;
		but.focus_mode = Button.FOCUS_NONE;
		container.add_child(but);
		but.pressed.connect(OnQuestSelected.bind(cur));

func ClearSteps() -> void:
	for child in stepsContainer.get_children():
		child.queue_free();

func OnQuestSelected(quest: GamePlayerQuest) -> void:
	ClearSteps();
	var ref: GameQuest = quest.instance;
	titleLabel.text = ref.name;
	descriptionLabel.text = ref.description;
	for i in range((quest.step) + 1): # Argument is exclusive, so need to add 1 to get the current step
		var step: GameQuestStep = quest.instance.steps[i];
		var l: RichTextLabel = stepLabel.instantiate();
		if(i < quest.step):
			l.text = GameText.Format("[color=#57606f]{fmt}[/color]".format({"fmt":step.description}));
		else:
			l.text = GameText.Format(step.description);
		stepsContainer.add_child(l);
