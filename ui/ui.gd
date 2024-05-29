extends Control
class_name GameCoreControl;

const MAX_HISTORY: int = 25;

@onready var _areaControl: GameAreaController = $"AreaControl";
@onready var _narrator: GameNarrator = $"Narrator";
@onready var _uiRoomName: Label = $"Panel/MarginContainer/HBoxContainer/Left/GameInfo/MarginContainer/VBoxContainer/RoomTitle";
@onready var _uiOptionContainer: GameOptionGrid = $"Panel/MarginContainer/HBoxContainer/Middle/Panel/GameOptionGrid";
@onready var _uiContent: GameContentContainer = $"Panel/MarginContainer/HBoxContainer/Middle/GameContent";
@onready var _moveTimer: Timer = $"MoveTimer";
@onready var _optionHint: GameOptionHint = $"OptionHint";
@onready var worldViewport: GameWorldViewport = $"Panel/MarginContainer/HBoxContainer/Left/GameInfo/MarginContainer/VBoxContainer/Panel/MarginContainer/WorldViewport";

var _canMove: bool = true;
var inScene: bool = false;
var userInput: GameInputResponse = null;

const MOVE_TIME_SEC: float = 0.15;

func _ready() -> void:
	_optionHint.set_process(false);
	
	_narrator.quest_progress.connect(_uiContent.UpdateQuests);
	_uiContent.FillQuests(_narrator.GetPlayer().Quests());
	
func GameTick() -> void:
	## PushGameResponse(str(_narrator.GetPlayer().Quests().GetStatus("test_quest")));
	return;
	
func MoveTo(x: int, y: int) -> void:
	_areaControl.MoveTo(x,y)
	TranslateCameraToPlayerPosition();		
	return;

func MoveToNamed(index: String) -> bool:
	if(_areaControl.MoveToNamed(index)):
		TranslateCameraToPlayerPosition();
		return true;
	return false;

func ChangeGameArea(index: String) -> void:
	worldViewport.AddAreaInstance(_areaControl.ChangeArea(index))
	return;

func TranslateCameraToPlayerPosition() -> void:
	worldViewport.MoveCameraTo(_areaControl.GetCurrentArea().GetCurrentRoom().position);
	return;

func PushGameResponse(gameText: String) -> void:
	_uiContent.PushResponse(gameText);
	
func PushOption(option: GameUIOption, index: int) -> void:
	_narrator.AddOption(option);
	_uiOptionContainer.AddUIButton(option, index);
	return;
	
func ChangeArea(args: PackedStringArray) -> void:
	var nextName: String = args[0];
	if(_areaControl.ChangeArea(nextName)):
		var roomName: String = args[1];
		MoveToNamed(roomName);
		RoomEntered();
	return;

func OnSceneText(text: String) -> void:
	PushGameResponse(GameText.Format(text));

func OnSceneOptions(options: Array[GameUIOption]) -> void:
	_narrator.ClearOptions();
	_uiOptionContainer.ClearButtons();
	var index: int = 0;
	for option: GameUIOption in options:
		PushOption(option, index);
		index += 1;
	return;

func OnSceneEnter() -> void:
	#_canMove = false;
	inScene = true;
	_uiOptionContainer.ClearButtons();
	_uiContent.ClearHistory();

func OnSceneExit() -> void:
	RoomEntered();
	#_canMove = true;
	inScene = false;
	
func HookInput(input: GameInputResponse) -> void:
	if(UnhookInput()):
		printerr("Warning: Previous input field dropped without handling.");
	_narrator.GetPlayer().RemoveFlag(Game.UI_INPUT_FLAG);		
	userInput = input;
	userInput.input.text_changed.connect(OnUserInputTextChanged);
	return;
	
func UnhookInput() -> bool:
	if(userInput):
		userInput.Disable();
		Game.UI_INPUT_BUFFER = userInput.input.text;
		if(userInput.input.text_changed.is_connected(OnUserInputTextChanged)):
			userInput.input.text_changed.disconnect(OnUserInputTextChanged);
			return _narrator.GetPlayer().CheckFlag(Game.UI_INPUT_FLAG);
	return false;

func OnUserInputTextChanged(_newmsg: String) -> void:
	if(_newmsg.is_empty()):
		_narrator.player.RemoveFlag(Game.UI_INPUT_FLAG);
	else:
		_narrator.player.SetFlag(Game.UI_INPUT_FLAG);
	return;
	
func OnSceneEvent(type: Enums.SceneEvent, args: PackedStringArray) -> void:
	match(type):
		Enums.SceneEvent.transport:
			if(args.size() == 2):
				ChangeGameArea(args[0]);
				#if(not _areaControl.ChangeArea(args[0])):
					#printerr("No area named: " + args[0]);
				if(not MoveToNamed(args[1])):
					printerr("No room in area named: " + args[1]);
				_uiRoomName.text = _areaControl.GetCurrentArea().GetCurrentRoom().GetName();
			else:
				printerr("Transport call requires 2 arguments. [area_name,room_name]");
		Enums.SceneEvent.movement:
			if(args.size() == 1):
				if(not MoveToNamed(args[0])):
					printerr("No room found in area: " + args[0]);
				_uiRoomName.text = _areaControl.GetCurrentArea().GetCurrentRoom().GetName();				
			else:
				printerr("movement event requires 1 argument. [room_name]");
		Enums.SceneEvent.input:
			HookInput(_uiContent.PushInput(args[0]));
		Enums.SceneEvent.inputhandled:
			UnhookInput();
		Enums.SceneEvent.uiclear:
			_uiContent.ClearHistory();
			
		_:
			print("WHAT");
	return;
	
func ConstructCharacterOption(character: GameCharacter) -> GameUIOption:
	return GameUIOption.new(_narrator.EnterScene.bind(character.dialogue), character.name, "Approach " + character.name);
	
func ConstructStaticOption(container: GameRoomSceneContainer) -> GameUIOption:
	return GameUIOption.new(_narrator.EnterScene.bind(container.scene), container.name, container.description);

func FillRoomOptions() -> void:
	_uiOptionContainer.ClearButtons();
	_narrator.ClearOptions();
	var room: GameRoom = _areaControl.GetCurrentArea().GetCurrentRoom();
	var index: int = 0;
	for scene: GameRoomSceneContainer in room.GetScenes().values():
		PushOption(ConstructStaticOption(scene), index);
		index += 1;
	for char: GameCharacter in room.GetCharacters().values():
		PushGameResponse(GameText.Format("{{char}} is in the area.".format({"char":char.index})));
		PushOption(ConstructCharacterOption(char), index);
		index += 1;
	return;
	
func RoomEntered() -> void:
	_uiContent.ClearHistory();
	_narrator.ClearOptions();
	_uiRoomName.text = _areaControl.GetCurrentArea().GetCurrentRoom().GetName();
	PushGameResponse(GameText.Format(_areaControl.GetCurrentArea().GetCurrentRoom().GetDescription()));
	FillRoomOptions();
	
## TODO: This ignores narrator!!!
func _input(event: InputEvent) -> void:
	var didMove: bool = false;
	if(_canMove and (not inScene)):
		if(not _moveTimer.time_left):
			if(event.is_action_pressed("moveNorth")):
				didMove = _areaControl.AttemptMove(Enums.MoveDirection.north);
			elif(event.is_action_pressed("moveEast")):
				didMove = _areaControl.AttemptMove(Enums.MoveDirection.east);
			elif(event.is_action_pressed("moveSouth")):
				didMove = _areaControl.AttemptMove(Enums.MoveDirection.south);
			elif(event.is_action_pressed("moveWest")):
				didMove = _areaControl.AttemptMove(Enums.MoveDirection.west);
			if(didMove):
				_moveTimer.start(MOVE_TIME_SEC);
				_onGameOptionExited(null); # what the fuck
				TranslateCameraToPlayerPosition();
				RoomEntered();
				GameTick();
	return;

func _onUIOptionActivated(index: int) -> void:
	_narrator.CallOption(index);
		
func _onGameOptionHovered(_button: GameOptionButton) -> void:
	_optionHint.set_process(true);
	_optionHint.visible = true;
	_optionHint.SetOption(_narrator.GetOption(_button.rawOptionIndex));
	
func _onGameOptionExited(_button: GameOptionButton) -> void:
	_optionHint.visible = false;
	_optionHint.set_process(false);

func _onPageChanged(controls: bool) -> void:
	_canMove = controls;
	$"Panel/MarginContainer/HBoxContainer/Middle/Panel/GameOptionGrid".visible = controls;
	return;
