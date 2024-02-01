module Nonempty

# ? need to copy a type `NotEmpty{T}` similar to `Some{T}`?

export nonempty, @nonempty

"""
    nonempty(x...)
Similar to [nonempty](@ref) and [coalesce](@ref).

Return the first value in the arguments which is not empty according to [`isempty`](@ref),
if any. Otherwise throw an error.

See also [`@something`](@ref), [`coalesce`](@ref), [`skipmissing`](@ref).

# Examples
```jldoctest
julia> nonempty([], 1)
1

julia> nonempty("1", [])
"1"

julia> nonempty([],"", tuple(), "", ``, 1)


julia> @nonempty "" readline() 1
not empty
"not empty"

julia> @nonempty "" readline() 1

1

julia> nonempty("", [])
ERROR: ArgumentError: No value arguments present
```
"""
function nonempty end

nonempty() = throw(ArgumentError("No value arguments present"))
nonempty(x, args...) = isempty(x) ? nonempty(args...) : x

"""
    @nonempty(x...)

Short-circuiting version of [`nonempty`](@ref).

# Examples
```jldoctest
julia> f(x) = (println("f(\$x)"); []);

julia> a = 1;

julia> a = @nonempty a f(2) f(3) error("Unable to find default for `a`")
1

julia> b = "";

julia> b = @nonempty b f(2) f(3) error("Unable to find default for `b`")
f(2)
f(3)
ERROR: Unable to find default for `b`
[...]

julia> b = @nonempty b f(2) f(3) "1"
f(2)
f(3)

julia> b === "1"
true
```
"""
macro nonempty(args...)
    expr = ""
    for arg in reverse(args)
        expr = :(val = $(esc(arg)); isempty(val) ? ($expr) : val)
    end
    nonempty = GlobalRef(Nonempty, :nonempty)
    return :($nonempty($expr))
end

end # module Nonempty
