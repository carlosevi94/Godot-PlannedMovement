extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var cruces = 0
var plan = []

var next_plan_site = Vector2(0,0)

var activa_plan = false

func _physics_process(delta):

	if activa_plan:
		if len(plan) != 0:
			next_plan_site = plan[0]

			if position.distance_to(next_plan_site) > 3:
				var target_position = (next_plan_site - position).normalized()
				velocity = target_position * SPEED
			else:
				plan.pop_front()
				if len(plan) == 0:
					activa_plan = false
					borrar_plan()

	else:
		velocity = Vector2(0,0) * SPEED


	move_and_slide()
	animation_controller()


func crear_marca(vector_pos):
	var scene = load("res://gameplay/cruz.tscn")
	var scene_instance = scene.instantiate()
	get_parent().add_child(scene_instance)
	scene_instance.global_position = vector_pos
	scene_instance.set_name("cruz")
	plan.append(vector_pos)

func borrar_plan():
	for hijo in get_parent().get_children():
			if hijo.name.contains('cruz'):
				hijo.queue_free() 

# Botón liberar plan
func _on_button_pressed():
	activa_plan = false
	plan = []
	borrar_plan()

# Botón activar plan
func _on_b_execute_pressed():
	activa_plan = true
	

# Detectar que estás pulsando dentro del area de juego
func _on_area_2d_input_event(viewport, event, shape_idx):
	if event.is_class("InputEventMouseButton"):
		var mouse_position = viewport.get_mouse_position()
		crear_marca(mouse_position) 


func animation_controller():
	
	if velocity.x < 0:
		$animaciones.flip_h = false
		$animaciones.play("correr")
	elif velocity.x > 0:
		$animaciones.play("correr")
		$animaciones.flip_h = true
	elif velocity.y < 0:
		$animaciones.play("arriba")
	elif velocity.y > 0:
		$animaciones.play("abajo")
		
