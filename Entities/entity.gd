extends Node2D

enum CELL_TYPES { PLAYER, WALL, ENEMY }
export(CELL_TYPES) var type = CELL_TYPES.PLAYER
