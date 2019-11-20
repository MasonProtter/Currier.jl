module Currier

export @curried

struct FullyCurried end

macro curried(fdef)
    f = fdef.args[1].args[1]
    fargs = fdef.args[1].args[2:end]
    arity = length(fargs)
    body = fdef.args[2]
    err_str = "Too many arguments. Function $f only takes $arity arguments"
    quote 
        begin 
            function $f(args...)
                if length(args) < $arity
                    x -> $f((args..., x)...)
                elseif length(args) == $arity
                    $f(Currier.FullyCurried(), args...)
                else
                    throw($err_str)
                end
            end
            $f(::Currier.FullyCurried, $(fargs...)) = $body
        end
    end |> esc
end

end # module
