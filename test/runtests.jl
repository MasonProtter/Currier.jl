using Test, Currier

@curried foo(x, y, z) = (x^2 + y^2)/(x^2 + y^2 +z^2)

@test foo(1)(2)(3) == foo(1, 2, 3)

@reverse_curried bar(x, y, z, w) = (x, y, z, w)

@test bar(1)(2)(3)(4) == bar(4, 3, 2, 1)
