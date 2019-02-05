
sumator : ()
  num a, b, c, d
  a = 1
  b = 2
  c = 4
  d = 8
  num i, j, k, l, res
  for i = a to b do
    for j = b to c do
      for k = c to d do
        res++
  . . .
  if res > 1 then
    print 1
  else
    if res > 2 then
      print 2
    else
      if res > 3 then
        print 3
      else
        if res = 4 then
          print 4
        .
        if res = 5 then
          print 5
        .
        if res = 6 then
          print 6
. . . .
  print res
.

