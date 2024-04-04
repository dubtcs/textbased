extends Resource
class_name CharacterDialogueOption;

## Text displayed for the option button
@export var buttonText: String = "";

## Subtext for the hover hint
@export var buttonHint: String = "";

@export_multiline var responses: Array[String] = [];

## Follow up options
@export var responseOptions: Array[int] = [];

## Kick the player out after this option
@export var forceEndConvo: bool = false;
