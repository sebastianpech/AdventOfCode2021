function parse_input(path)
    mapreduce(permutedims, vcat, map.(x->parse.(Int,x),split.(readlines(path),"")))
end

grid = parse_input("15.input")

function find_path(grid)
    distances = ones(Int, size(grid)...)*1000000 # Init as very high
    predecessors = Matrix{CartesianIndex{2}}(undef, size(grid)...)
    notvisited = CartesianIndices(grid)[:]
    distances[1,1] = 0
    predecessors[1,1] = CartesianIndex(0,0)
    Δs = (CartesianIndex(1,0), CartesianIndex(-1,0), CartesianIndex(0,1), CartesianIndex(0,-1))
    while length(notvisited) > 0
        weight, idx  = findmin(x->distances[x],notvisited)
        current = notvisited[idx]
        deleteat!(notvisited, idx)
        # Check neigbours
        for Δ in Δs
            n = current + Δ
            if checkbounds(Bool, grid, n)
                distances[n] = min(distances[n], weight+grid[n])
            end
        end
    end
    return distances[end,end]
end
s = find_path(grid)

# Part 2
function generate_expanded_cave(grid)
    new_data = zeros(Int, (size(grid).*5)...)
    h,w = size(grid)
    for r in 1:5
        for c in 1:5
            new_data[(r-1)*h+1:h*r,(c-1)*w+1:w*c] = mod1.(grid+ones(Int, h, w)*(r+c-2), Ref(9))
        end
    end
    new_data
end
new_grid = generate_expanded_cave(grid)
find_path(new_grid)
