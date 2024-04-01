extends Resource
class_name CharacterDialogueOption;

## Text displayed for the option button
@export var buttonText: String = "";

## Subtext for the hover hint
@export var buttonHint: String = "";

## Displayed text the player will say in the narrator
@export_multiline var playerText: String = "";

## Displayed text the character will respond with
@export_multiline var characterResponse: String = "";

## Follow up options
@export var responseOptions: Array[int] = [];
