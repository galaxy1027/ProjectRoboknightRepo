extends CharacterBody2D

## This is the base enemy class with useful functions and atributes
class_name base_enemy

## Refrence to the enemy's health object, REQUIRED(you can turn it off if you want them invincible or something)
@export var MY_HEALTH:health

## The player's instance
var target:CharacterBody2D = null

func _ready() -> void:
	# assert(is_instance_valid(MY_HEALTH), "Enemy must have a health object") # IF THIS TRIGGERS IT MEANS YOU DIDN'T ADD A "health" NODE INTO THE "My Health" SLOT IN THE INSPECTOR
	
	# Temporarly made health object optional for testing
	if !is_instance_valid(MY_HEALTH):
		printerr("ENEMY IS MISSING A HEALTH NODE")


## The maximum speed the enemy can move
@export var _MAX_SPEED:float = 100.0
## How fast the enemy can change directions and get up to speed
@export var _ACCELERATION:float = 80.0

## The general direction the enemy is facing, +x is right, +y is down
var direction:Vector2 = Vector2(0,1)

## Example of an enum
enum {DEAD, IDLE, PURSUING, ATTACKING}
## The state the enemy is currently in
var STATE:int = IDLE
## The previous state if required to change things around on a state change
var STATE_P:int = STATE

## A function to keep track of state changes 
func change_state(new_state:int)->void:
	#print_debug(new_state)
	if STATE != DEAD:
		STATE = new_state

## takes a destination vector and returns a velocity to get to the destination
func go_to(destination:Vector2)->Vector2:
	var direction = position.direction_to(destination)
	
	var return_velocity = velocity
	return_velocity.y = move_toward(velocity.y, direction.y*_MAX_SPEED, _ACCELERATION)
	return_velocity.x = move_toward(velocity.x, direction.x*_MAX_SPEED, _ACCELERATION)
	return return_velocity

## Checks if given position is to the left of the enemy
func is_to_my_left(position:Vector2)->bool:
	if (global_position.x - position.x) < 0: #Is to the left
		return true
	else:
		return false

## Checks if a given position is above the enemy
func is_above_me(position:Vector2)->bool:
	if (global_position.y - position.y) < 0: #Is above
		return true
	else:
		return false
