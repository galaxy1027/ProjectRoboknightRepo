extends Area2D

## The hurt_box node detects health nodes on specified collision masks and connects and emits a hit signal to it
class_name hurt_box

## This signal is sent to a health node detailing the amount of damage it should cause, the knockback force, and which way the damage is coming from 
signal hit(damage:int, knockback:float, direction:Vector2)

## This signal optionally allows the node that it's attatched to know when it hits something
signal i_hit()

## The amount of damage the hurt_box causes
@export var _damage:int = 10
## The strength of knock back the hurt_box causes
@export var _knockback_strength:float = 10.0

func _ready() -> void:
	if self.monitorable == true:
		self.set_deferred("monitorable", false)
	
	# Checks if hurt box is set to a collision mask
	if self.collision_mask == 0:
		printerr("HURTBOX IS NOT SET ON A COLLISION MASK AND CANNOT DETECT HEALTH BOXES")
	
	# checks if signals are connected properly
	if !self.area_entered.is_connected(self._on_area_entered):
		self.area_entered.connect(self._on_area_entered)
	
	if !self.area_exited.is_connected(self._on_area_exited):
		self.area_exited.connect(self._on_area_exited)

## Enables the hit box
func enable()->void:
	if self.monitoring == false:
		self.set_deferred("monitoring", true)

## Disables the hit box
func disable()->void:
	if self.monitoring == true:
		self.set_deferred("monitoring", false)

func hit_him():
	emit_signal("hit", _damage, _knockback_strength, 0)

## If a health area is detected the hit signal is connected and emited.
func _on_area_entered(area: Area2D) -> void:
	if area.name.containsn("hit") or area.name.containsn("health"):
		self.hit.connect(area._on_hit)
		emit_signal("hit", _damage, _knockback_strength, global_position.direction_to(area.global_position))
		emit_signal("i_hit")
		pass

## When a health area leaves the hurt box the signal is disconnected
func _on_area_exited(area: Area2D) -> void:
	if self.hit.is_connected(area._on_hit):
		print(area.name)
		self.hit.disconnect(area._on_hit)
