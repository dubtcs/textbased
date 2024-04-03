extends Resource
class_name CharacterDialogue;

@export var character: GameCharacter = null;
@export var startingOptions: Array[int] = [];
@export var dialogues: Array[CharacterDialogueOption] = [];
