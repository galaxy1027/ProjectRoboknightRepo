extends base_enemy

@onready var rand = RandomNumberGenerator.new() 
enum {_death_,_idle_, TARGET, SPRAY, ERUPT}

var _attacking:bool = false
var _cooldown:bool = false

var fireball := preload("res://Entites/Moveables/Enemies/DRAGON/fireball.tscn")

var phase:Array[float] = [70,101,.4,.6,2]

const phase_1:Array[float] = [60,90,.4,.6,2]
const phase_2:Array[float] = [30,70,.1,.4,1.2]
const phase_3:Array[float] = [5,55,.05,.1,.4]

func _ready() -> void:
	target = get_parent().get_node("./Player")
	target.global_position


var target_last_location:Vector2 = Vector2.ZERO
func _physics_process(delta: float) -> void:
	_state_handler()
	target_last_location = target.global_position
	pass
	

var target_loop:int = 0
var target_itt:int = 0
func _state_handler()->void:
	var frame := _head_animation()
	match STATE:
		DEAD:
			pass
		IDLE:
			if _attacking:
				_attacking = false
			if !_cooldown:
				var choice := rand.randi_range(0,100)
				if choice < phase[0]:
					change_state(TARGET)
				elif choice < phase[1]:
					change_state(SPRAY)
				else:
					change_state(ERUPT)
		TARGET:
			if frame == 4:
				var new_fireball := fireball.instantiate()
				# set direction to target
				new_fireball.direction = target.global_position + 50*(target.global_position - target_last_location)
				# spawn in bullet
				new_fireball.global_position = $HEAD/Marker2D.global_position
				get_parent().add_child(new_fireball)
				_cooldown = true
				$cooldown.wait_time = phase[2]
				$cooldown.start()
				_attacking = true
				change_state(IDLE)
		SPRAY:
			if target_loop == 0:
				target_loop = rand.randi_range(5,14)
			elif target_loop <= target_itt:
				target_loop = 0
				target_itt = 0
				_cooldown = true
				$cooldown.wait_time = phase[3]
				$cooldown.start()
				change_state(IDLE)
			elif frame == 4:
				var new_fireball := fireball.instantiate()
				# set direction to target
				new_fireball.direction = Vector2(target.global_position.x + rand.randi_range(-500,500), target.global_position.y)
				# spawn in bullet
				new_fireball.global_position = $HEAD/Marker2D.global_position
				get_parent().add_child(new_fireball)
				_attacking = true
				target_itt += 1
			elif _attacking:
				_attacking = false
				
		ERUPT:
			if target_loop == 0:
				target_loop = rand.randi_range(50,80)
			elif target_loop <= target_itt:
				target_loop = 0
				target_itt = 0
				_cooldown = true
				$cooldown.wait_time = phase[4]
				$cooldown.start()
				change_state(IDLE)
			elif frame == 4:
				var new_fireball := fireball.instantiate()
				# set direction to target
				new_fireball.direction = target.global_position + 90*(target.global_position - target_last_location)
				# spawn in bullet
				new_fireball.global_position = $HEAD/Marker2D.global_position
				get_parent().add_child(new_fireball)
				_attacking = true
				target_itt += 1
			elif _attacking:
				_attacking = false
		_:
			printerr("DRAGON STATE ERROR")


func _head_animation()->int:
	# I KNOW THE NESTED IF STATEMENTS IS UGLY, I'M NOT GONNA FIX IT
	if !_attacking and STATE != DEAD:
		$HEAD.look_at(target.global_position)
		$HEAD.rotation_degrees -= 90
		if cos($HEAD.rotation) < PI/4:
			if sin($HEAD.rotation) < 0:
				$HEAD.rotation_degrees += 45
				if $HEAD.animation != "SIDE":
					$HEAD.flip_h = true
					$HEAD/Marker2D.position = Vector2(39,85)
					$HEAD.animation = "SIDE"
			else:
				$HEAD.rotation_degrees -= 45
				if $HEAD.animation != "SIDE":
					$HEAD.flip_h = false
					$HEAD/Marker2D.position = Vector2(-39,85)
					$HEAD.animation = "SIDE"
		elif $HEAD.animation != "FACE":
			$HEAD.animation = "FACE"
			$HEAD/Marker2D.position = Vector2(0,104)
	
	match STATE:
		DEAD:
			return 0
		IDLE:
			if $HEAD.frame > 0:
				$HEAD.play_backwards()
			else:
				$HEAD.pause()
		TARGET:
			if !$HEAD.is_playing():
				$HEAD.play()
		SPRAY:
			if $HEAD.frame == 4:
				$HEAD.play_backwards()
			elif $HEAD.frame <= 1:
				$HEAD.play()
		ERUPT:
			if $HEAD.frame == 4:
				$HEAD.play_backwards()
			else:
				$HEAD.play()
		_:
			printerr("DRAGON STATE ERROR")
	return $HEAD.frame


func _on_body_animation_finished() -> void:
	if STATE == DEAD:
		return
	if $BODY.animation == "IDLE":
		if $BODY.frame == 0:
			$BODY.play()
		else:
			$BODY.play_backwards()


func _on_cooldown_timeout() -> void:
	_cooldown = false

var quick = preload("res://Assets/Music/RetroFury_Triumph.mp3")
func _on_death() -> void:
	get_parent().get_node("AudioStreamPlayer2D").set_stream(quick)
	change_state(DEAD)
	$BODY.play("DIE")
	$HEAD.play("DIE")
	$AnimationPlayer.play("DEAD")


func _on_health_knock_back(direction: Vector2, weight: float) -> void:
	var health_ration:float = float($health.my_health)/float($health.max_health)
	if health_ration < .20:
		phase = phase_3
	elif health_ration < .55:
		phase = phase_2
	else:
		phase = phase_1
	


func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	#DIED
	get_tree().change_scene_to_file("res://Levels/END.tscn")
