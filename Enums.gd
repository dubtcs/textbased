extends Node

# PLAYER INPUT
enum ActionType { invalid, 	movement, interaction, meta };
enum MoveDirection { north = 0, east = 1, south = 2, west = 3 };

# QUESTS
enum QuestStep { none, flag, kill, possess };
enum QuestStatus{ available, inProgress, complete };

# ROOMS
enum ExitType { open, closed, keyed };
enum RoomIcon { empty, bed, kitchen, stairs, lock, door, cook, mouse, cpu, circuit, home };
enum RoomColor { none, red, blue, yellow, green };

# SCENES
enum SceneEvent { transport };

# STORY
enum CharacterGender { male = 0, female = 1, neutral = 2 };
