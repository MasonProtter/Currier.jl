module Currier

export @curried, @reverse_curried

struct FullyCurried end

macro curried(fdef)
    f     = esc(fdef.args[1].args[1])
    fargs = esc.(fdef.args[1].args[2:end])
    arity = length(fargs)
    body  = esc(fdef.args[2])
    err_str = "Too many arguments. Function $f only takes $arity arguments"
    quote 
        begin 
            function $f(args...)
                if length(args) < $arity
                    x -> $f((args..., x)...)
                elseif length(args) == $arity
                    $f(FullyCurried(), args...)
                else
                    throw($err_str)
                end
            end
            $f(::FullyCurried, $(fargs...)) = $body
        end
    end
end

macro reverse_curried(fdef)
    f     = esc(fdef.args[1].args[1])
    fargs = esc.(fdef.args[1].args[2:end])
    arity = length(fargs)
    body  = esc(fdef.args[2])
    err_str = "Too many arguments. Function $f only takes $arity arguments"
    quote 
        begin 
            function $f(args...)
                if length(args) < $arity
                    x -> $f((x, args...)...)
                elseif length(args) == $arity
                    $f(FullyCurried(), args...)
                else
                    throw($err_str)
                end
            end
            $f(::FullyCurried, $(fargs...)) = $body
        end
    end
end


end # module
