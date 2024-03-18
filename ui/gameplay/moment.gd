extends VBoxContainer

func SetPlayerInput(msg: String, res: String) -> void:
	$InputEcho.text = ":: " + msg;
	$Label.text = res;
