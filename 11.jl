data = reduce(vcat, permutedims.((x->parse.(Int,x)).(split.(readlines("11.input"),""))))

const Δ_pos = (CartesianIndex(1,0), CartesianIndex(-1,0), CartesianIndex(0,1), CartesianIndex(0,-1), CartesianIndex(-1,-1), CartesianIndex(-1,1), CartesianIndex(1,1), CartesianIndex(1,-1))
valid_index(x,data) = x[1] > 0 && x[2] > 0 && x[1] <= size(data,1) && x[2] <= size(data,2)

function flash!(data, x)
    for Δ in Δ_pos
        p = x+Δ
        valid_index(p, data) || continue
        data[p] += 1
    end
end

function simulation_step!(working_array, data)
    # Incrase by 1
    working_array .= data .+1
    flashing = Set(findall(>(9), working_array))
    flashed = Set{CartesianIndex{2}}()
    while length(flashing) > 0
        for p in flashing
            flash!(working_array, p)
            working_array[p] = -100
            push!(flashed, p)
        end
        flashing = Set(findall(>(9), working_array))
    end
    for p in flashed
        working_array[p] = 0
    end
    data .= working_array
    return length(flashed)
end

# Part 1
_data = copy(data)
working_array = similar(_data)
sum([simulation_step!(working_array, _data) for _ in 1:100])

# Part 2
_data = copy(data)
working_array = similar(_data)
step = 0
while any(>(0),_data)
    step += 1
    simulation_step!(working_array, _data)
end
step