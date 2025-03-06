class_name Item

var number: int = 0

func setNumber(_number: int):
	number = _number

func increment():
	number += 1

func decrement():
	if number > 0:
		number -= 1
