main : ()
	num a, b
	num c = 3
	a = 1
	b == sumator(1, 2, 3, 4)
	print b
.

helper : (num a, num b)
	print a * b
.

sumator : (num a, num b, num c, num d)
	num i, j, k, res
	for i = a to b do
		for j = b to c do
			for k = c to d do
				res = res + 1
	.	.	.
	return res
.