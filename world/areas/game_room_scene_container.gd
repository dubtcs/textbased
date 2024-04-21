extends Resource
class_name GameRoomSceneContainer;

## The text that will be displayed on the button
@export var name: String = "";
## The text that will be displayed on the button's hover menu
@export var description: String = "";
## The script containin scene functionality
@export var sceneScript: GDScript = null;

var scene: GameScene = null;
