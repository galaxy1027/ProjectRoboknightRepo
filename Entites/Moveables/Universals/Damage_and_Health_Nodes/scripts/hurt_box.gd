extends Area2D

## The hurt_box node detects health nodes on specified collision masks and connects and emits a hit signal to it
class_name hurt_box

## This signal is sent to a health node detailing the amount of damage it should cause, the knockback force, and which way the damage is coming from 
signal hit(damage:int, knockback:float, direction:Vector2)

## The amount of damage the hurt_box causes
@export var _damage:int = 10
## The strength of knock back the hurt_box causes
@export var _knockback_strength:float = 10.0

## Enables the hit box
func enable()->void:
	if self.monitoring == false:
		self.set_deferred("monitoring", true)

## Disables the hit box
func disenable()->void:
	if self.monitoring == true:
		self.set_deferred("monitoring", false)

## If a health area is detected the hit signal is connected and emited.
func _on_area_entered(area: Area2D) -> void:
	if area.name.containsn("hit") or area.name.containsn("health"):
		self.hit.connect(area._on_hit)
		emit_signal("hit", _damage, _knockback_strength, global_position.direction_to(area.global_position))
		pass

## When a health area leaves the hurt box the signal is disconnected
func _on_area_exited(area: Area2D) -> void:
	if area.name.containsn("hit") and self.hit.is_connected(area._on_hit):
		self.hit.disconnect(area._on_hit)
