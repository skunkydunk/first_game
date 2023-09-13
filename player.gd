extends RigidBody3D
#define variables for use in "unhandled_input" function for mouse tracking
#speed at which camera moves w/ mouse
var mouse_sensitivity := 0.001
#stores how much mouse has moved horizontally and vertically every frame
var twist_input := 0.0
var pitch_input := 0.0

#new feature called annotations
#clarifies that these variables are related to the nodes
#essentialy gives the node references shorter names, now they can be accessed using the shorter var names
@onready var twist_pivot := $TwistPivot
@onready var pitch_pivot := $TwistPivot/PitchPivot

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input := Vector3.ZERO
	#sets the x-axis value to -1.0 when A is pressed, +1.0 when D is pressed, or 0 when neither are pressed.
	input.x = Input.get_axis("move_left", "move_right")
	#sets the y-axis value in a similar way
	input.z = Input.get_axis("move_forward","move_back")
	
	#basis thing makes it so that the camera's twist or orientation is considered as the forward direction
	apply_central_force(twist_pivot.basis * input * 1200.0 * delta)
	
	if Input.is_action_just_pressed("ui_cancel"):
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		
	#dollar symbol accesses node
	#rotate.y function rotates the node on the y axis by a specified number of radians (twist_input)
	twist_pivot.rotate_y(twist_input)
	#same for rotate.x
	pitch_pivot.rotate_x(pitch_input)
	#clamping or limiting x(vertical) rotation from mouse so the scene never goes upside-down
	#clamp takes (input modifying, input min, input max) - super useful for setting boundaries on values 
	pitch_pivot.rotation.x = clamp(
		pitch_pivot.rotation.x,
		
		#converts degrees to radians
		deg_to_rad(-30),
		deg_to_rad (30)
	)
	twist_input = 0.0
	pitch_input = 0.0


	
#this is a big function
#this function runs every time an event is detected that has not already been handled by another script
	#could be a lot of different events 
func _unhandled_input(event: InputEvent):
	#checks if event is mousemotion, and then checks if the mousemode is captured
	if event is InputEventMouseMotion:
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED: 
			#these set the twist and pitch input values to event.relative
			#event.relative stores how far the mouse has moved (set to negative so that camera moves the right way)
			#mouse sensitivity sets how fast camera rotates
			twist_input = - event.relative.x * mouse_sensitivity
			pitch_input = - event.relative.y * mouse_sensitivity
		
	
