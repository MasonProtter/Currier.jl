[![Build Status](https://travis-ci.com/MasonProtter/Currier.jl.svg?branch=master)](https://travis-ci.com/MasonProtter/Currier.jl)

# Currier.jl

Julia's multiple dispatch offers a lot of expressive power which is a strict superset of things like currying in Haskell. 
However, sometimes it's convenient to have currying and one doesn't want to write out the methods themselves. Enter Currier.jl
```julia
using Currier

@curried foo(x, y, z) = (x^2 + y^2)/(x^2 + y^2 +z^2)
```
```julia
julia> foo(1)(2)(3)
0.35714285714285715

julia> foo(1, 2, 3)
0.35714285714285715
```
Here's the (cleaned up) output code from applying `@curried` to our definition of `foo`. 
```julia
julia> @macroexpand @curried foo(x, y, z) = (x^2 + y^2)/(x^2 + y^2 +z^2)
quote
    begin
        function foo(args...)
            if length(args) < 3
                x-> foo((args..., x)...)
            elseif length(args) == 3
                foo(Currier.FullyCurried(), args...)
            else
                throw("Too many arguments. Function foo only takes 3 arguments")
            end
        end
        foo(::Currier.FullyCurried, x, y, z) = (x ^ 2 + y ^ 2) / (x ^ 2 + y ^ 2 + z ^ 2)
    end
end
```
