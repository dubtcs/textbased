extends GameScene

## FLOORS
# 0 - Room
# 1 - Ship

var floor: int = 1;

func _init() -> void:
	options = {
		"leave" = GameUIOption.new(LeaveShip, "Leave", "Leave your ship"),
		"enter" = GameUIOption.new(EnterShip, "Ship", "Enter your ship")
	};

func Opener() -> Array[GameUIOption]:
	PushText("You approach the airlock.");
	if(floor):
		return[ options.leave ];
	return [ options.enter ];

func LeaveShip() -> Array[GameUIOption]:
	floor = 0;
	PushText("You exit your ship.");
	push_event.emit(Enums.SceneEvent.transport, ["test_room","mainroom"]);
	return [];

func EnterShip() -> Array[GameUIOption]:
	floor = 1;
	PushText("You enter your ship.");
	push_event.emit(Enums.SceneEvent.transport, ["ship","airlock"]);
	return [];
