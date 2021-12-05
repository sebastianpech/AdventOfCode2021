data = readlines("5.input")

function parse_input(line)
    p1, p2 = String.(split(line, " -> "))
    (CartesianIndex(parse.(Int,split(p1, ","))...), CartesianIndex(parse.(Int,split(p2, ","))...)).+(CartesianIndex(1,1), CartesianIndex(1,1))
end

function to_range((p1, p2))
    p1 < p2 && return collect(p1:p2)[:]
    return collect(p2:p1)[:]
end

lines = reduce(vcat, to_range.(filter(parse_input.(data)) do l
    any(Tuple(l[1]) .== Tuple(l[2]))
end))

fields = zeros(Int, ((1,1).+Tuple(maximum(lines)))...);
foreach(lines) do p
    fields[p] +=1
end

function to_range_2((p1,p2))
    Δ = p2-p1
    if abs(Δ[1]) == abs(Δ[2])
        return [p1+CartesianIndex(i*sign(Δ[1]),i*sign(Δ[2])) for i in 0:abs(Δ[1])]
    end
    return to_range((p1, p2))
end

lines = reduce(vcat, to_range_2.(parse_input.(data)))

fields = zeros(Int, ((1,1).+Tuple(maximum(lines)))...);
foreach(lines) do p
    fields[p] +=1
end

count(>(1), fields)


