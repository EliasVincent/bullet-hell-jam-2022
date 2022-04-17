extends Area2D

export (float) var speed = 400
export (float) var time = 2.0
export (float) var initTime = 0.3
onready var timer = $Timer
onready var initTimer = $InitTimer
onready var sprite = $Sprite
onready var bSprite = $BSprite

export (Vector2) var velocity = Vector2()
export (bool) var use_velocity
#export (float) var rotation_change
var rotation_change = 0.0
var bulletColorString : String

var isIniting = true
# BulletSpawner where the original Bullet came from
var spawner
var flyToEnemyNow = false
var newParent : Node

enum ColorState {
	B,
	A
}
onready var color_state

func _ready():
	print("I'm instanced!")
	timer.start(time)
	initTimer.start(initTime)
	#TODO: set velocity and make it fly for a short while to have it actually around the player and not dead on him

func init():
	print("ParryBullet ColorState ", color_state)
	if color_state == ColorState.B:
		print("I SHOULD BE BLACK")
		sprite.hide()
		bSprite.show()
	else:
		sprite.show()
		bSprite.hide()
		color_state = ColorState.A


func _process(delta):
	# either use velocity or rotation
	if not flyToEnemyNow:
		if use_velocity:
			position += velocity.normalized() * speed * delta
		else:
			if isIniting:
				position += Vector2(cos(rotation), -sin(rotation)) * speed * delta
			else:
				position += Vector2(0,0)
		# super fancy spiral effect
		rotation_degrees += rotation_change * delta
	
	if flyToEnemyNow:
		position = position.move_toward(spawner.global_position, 400 * delta)

func fly_toward_enemy():
	print("before: ", global_position)
	var prevPos = global_position
	newParent = spawner.get_parent()
	get_parent().remove_child(self)
	newParent.add_child(self)
	flyToEnemyNow = true
	position = prevPos
	print("after: ", global_position)
	

func _on_VisibilityNotifier2D_screen_exited():
	#queue_free()
	pass


func _on_Timer_timeout():
	fly_toward_enemy()


func _on_InitTimer_timeout():
	isIniting = false
