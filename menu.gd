extends Control

var gameScene: PackedScene = preload("uid://c1eovoj2f2iih");

func OnNewPressed() -> void:
	var scene: GameCoreControl = gameScene.instantiate();
	get_tree().root.add_child(scene);
	scene._narrator.StartScene(scene._narrator.INTRO_SCENE);
	get_tree().root.remove_child(self);

func OnExitPressed() -> void:
	get_tree().quit();
