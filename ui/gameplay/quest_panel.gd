extends PanelContainer
class_name QuestPanel;

const STEPS_FORMAT: String = "[ol]{content}\n[/ol]"; ## First \n is missing bc of algo in UpdateSteps()

@onready var nameButton: Button = $"VBoxContainer/Button";
@onready var descriptionLabel: RichTextLabel = $"VBoxContainer/DescriptionLabel";
@onready var stepsLabel: RichTextLabel = $"VBoxContainer/StepsLabel";

var index: String = "";

func SetQuest(quest: GameQuest) -> void:
	nameButton.text = quest.name;
	descriptionLabel.text = quest.description;
	index = quest.index;
	
func UpdateSteps(pq: GamePlayerQuest) -> void:
	var stepsarr: Array[GameQuestStep] = pq.instance.steps.slice(0,pq.step + 1);
	var ins: String = "";
	for step: GameQuestStep in stepsarr:
		ins += "\n" + GameText.Format(step.description);
	stepsLabel.text = STEPS_FORMAT.format({"content":ins});

func HideContent() -> void:
	descriptionLabel.visible = false;
	stepsLabel.visible = false;
	
func ShowContent() -> void:
	descriptionLabel.visible = true;
	stepsLabel.visible = true;

func _OnButtonPressed() -> void:
	descriptionLabel.visible = not descriptionLabel.visible;
	stepsLabel.visible = not stepsLabel.visible;
	#pressed.emit(index);

# Can't have this when initializing
#func _init(quest: GameQuest) -> void:
	#SetQuest(quest);
