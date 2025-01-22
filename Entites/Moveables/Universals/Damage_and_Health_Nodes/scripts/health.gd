extends Area2D

## The health node deals with the health and damage being recived to an entity. The Node exists on a collision layer to be detectable to any hurt boxes.
class_name health

## Progress bar node path to be used as the health bar
@export_node_path("ProgressBar") var health_bar_scene:NodePath
## The progress bar NODE that will display health
@onready var health_bar:ProgressBar = get_node(health_bar_scene)

## When health reaches zero it emits this signal
signal on_death()

## When health is hit, it re-emits the knock back recived to be handled by what ever movment script
signal knock_back(direction:Vector2, weight:float)

## The maximum health the entity is allowed to have
@export var max_health:int = 100
## The amount of health the entity currently has
var my_health:int = 0
## This value will divide the damage recived so that it's less
var defence:int = 1
## When this is true the script will stop functioning
var _dead:bool = false

## Enables the hit box
func enable()->void:
	if self.monitorable == false:
		self.set_deferred("monitorable", true)

## Disables the hit box
func disable()->void:
	if self.monitorable == true:
		self.set_deferred("monitorable", false)

## When this node is loaded in it will set the health_bar to visible and set the health to max health
func _ready() -> void:
	health_bar.set_visible(true)
	health_bar.value = my_health

## When this function is called it will set _dead to true and emit on_death
func _kill()->void:
	_dead = true
	emit_signal("on_death")

## When called health is increased by the "heal" parameter, best used as a signal reciving function
func _on_healed(heal:int):
	if _dead: return
	my_health += heal
	if my_health > max_health: my_health = max_health
	health_bar.value = my_health

## When called health is decreased by parameter "damage" / defence. If health drops to 0 it calls _kill(). This function recives the "hit" signal from a hurt_box
func _on_hit(damage:int, _knock_back:float, _direction:Vector2):
	if _dead: return
	my_health -= damage/defence
	if my_health <= 0:
		_kill()
		health_bar.set_visible(false)
		return
	
	emit_signal("knock_back", _direction, _knock_back,)
	
	health_bar.value = my_health
