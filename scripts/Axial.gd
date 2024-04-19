extends RefCounted

# Axial vectors for hex coordinates
class_name Axial

#Starts top right, going clockwise
#static var axial_direction_vectors := [
#	[-1,1],[0,1],[1,0],
#	[1,-1],[0,-1],[-1,0]]

static var dirs : Array[Axial] =[
	Axial.new(-1,1),
	Axial.new(0,1),
	Axial.new(1,0),
	Axial.new(1,-1),
	Axial.new(0,-1),
	Axial.new(-1,0),
]

var r: int # vertical 
var q: int # horizontal 

func _init(_r: int, _q: int) -> void:
	self.r = _r
	self.q = _q

func add(axial: Axial) -> Axial:
	return Axial.new(r+axial.r, q+axial.q)

func neighbour(dir: int) -> Axial:
	return Axial.new(r+dirs[dir].r, q+dirs[dir].q)

func scale(factor: int) -> Axial:
	return Axial.new(r*factor, q*factor)

static func neighbour_s(axial: Axial, dir: int) -> Axial:
	return Axial.new(axial.r+dirs[dir].r, axial.q+dirs[dir].q)

static func add_s(axial1: Axial, axial2: Axial) -> Axial:
	return Axial.new(axial1.r + axial2.r, axial1.q + axial2.q)

static func ring(center: Axial, radius: int) -> Array[Axial]:
	var results: Array[Axial] = []
	var turtle: Axial = center.add(Axial.dirs[0].scale(radius))

	for side in range(0,6):
		for side_hex in range(radius):
			results.append(turtle)
			turtle = turtle.neighbour(side)
			
	return results

static func spiral(center: Axial, radius: int) -> Array[Axial]:
	var results : Array[Axial] = [center]
	for k in range(radius):
		results.append_array(ring(center, k))
	return results