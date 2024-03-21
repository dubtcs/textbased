extends Node

# PLAYER INPUT
enum ActionType { invalid, 	movement, interaction, meta };
enum MoveDirection { north = 0, east = 1, south = 2, west = 3 };

# ROOMS
enum ExitType { open, closed, keyed };
enum RoomIcon { empty, bed, kitchen, stairs, lock, door, cook, mouse, cpu, circuit, home };
enum RoomColor { none, red, blue, yellow, green };
