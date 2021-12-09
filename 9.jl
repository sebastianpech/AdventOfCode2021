data = reduce(vcat,permutedims.(map.(x->parse(Int,x),split.(readlines("9.input"),""))))

valid_index(i,j,data) = i > 0 && j > 0 && i <= size(data,1) && j <= size(data,2)
up_larger(i,j,data)    = !valid_index(i-1,j,data) || data[i,j] < data[i-1,j]
down_larger(i,j,data)  = !valid_index(i+1,j,data) || data[i,j] < data[i+1,j]
left_larger(i,j,data)  = !valid_index(i,j-1,data) || data[i,j] < data[i,j-1]
right_larger(i,j,data) = !valid_index(i,j+1,data) || data[i,j] < data[i,j+1]
is_minimum(i,j,data) = up_larger(i,j,data) && down_larger(i,j,data) && left_larger(i,j,data) && right_larger(i,j,data)

# Part 1
indices = CartesianIndices(data)[:]
minima = findall((idx)->is_minimum(idx[1],idx[2],data),indices)

# Part 2

up_basin(i,j,data)    = valid_index(i-1,j,data) && data[i-1,j] < 9 && data[i,j] < data[i-1,j]
down_basin(i,j,data)  = valid_index(i+1,j,data) && data[i+1,j] < 9 && data[i,j] < data[i+1,j]
left_basin(i,j,data)  = valid_index(i,j-1,data) && data[i,j-1] < 9 && data[i,j] < data[i,j-1]
right_basin(i,j,data) = valid_index(i,j+1,data) && data[i,j+1] < 9 && data[i,j] < data[i,j+1]

function find_basin(m, data)
    basin = Set([m])
    trial_points = Set([m])
    while length(trial_points) > 0
        tp = pop!(trial_points)
        if up_basin(tp[1], tp[2], data)
            p = tp+CartesianIndex(-1,0)
            push!(basin, p)
            push!(trial_points, p)
        end
        if down_basin(tp[1], tp[2], data)
            p = tp+CartesianIndex(1,0)
            push!(basin, p)
            push!(trial_points, p)
        end
        if right_basin(tp[1], tp[2], data)
            p = tp+CartesianIndex(0,1)
            push!(basin, p)
            push!(trial_points, p)
        end
        if left_basin(tp[1], tp[2], data)
            p = tp+CartesianIndex(0,-1)
            push!(basin, p)
            push!(trial_points, p)
        end
    end
    return basin
end

reduce(*,sort(length.(map(m->find_basin(m, data),indices[minima])))[end-2:end])



