data = split.(readlines("12.input"),"-")

function create_cave_structure(data)
    cs = Dict{String, Set{String}}()
    for (p,c) in data
        cs[p] = push!(get(cs, p, Set{String}()), c)
    end
    # Add reverse directions
    for (p,caves) in cs
        p == "start" && continue
        for c in caves
            cs[c] = push!(get(cs, c, Set{String}()), p)
        end
    end
    for (p,caves) in cs
        cs[p] = setdiff(caves, ["start"])
    end
    cs
end

# Part 1
function find_paths(data)
    cave_structure = create_cave_structure(data)
    search_paths = Set([["start"]])
    found_paths = Set{Vector{String}}()
    while length(search_paths) > 0
        current_path = pop!(search_paths)
        next_caves = [vcat(current_path, c) for c in cave_structure[current_path[end]] if isuppercase(c[1]) || !(c in current_path)]
        for n in next_caves
            if n[end] == "end"
                push!(found_paths, n)
            else
                push!(search_paths,n)
            end
        end
    end
    return found_paths
end
length(find_paths(data))

# Part 2
function find_paths(data)
    cave_structure = create_cave_structure(data)
    search_paths = Set([(["start"],false)])
    found_paths = Set{Vector{String}}()
    while length(search_paths) > 0
        current_path, contains_small = pop!(search_paths)
        for c in cave_structure[current_path[end]]
            if contains_small && islowercase(c[1]) && c in current_path
                continue
            end
            if c == "end"
                push!(found_paths, current_path)
            else
                if islowercase(c[1]) && c in current_path
                    push!(search_paths, (vcat(current_path, c), true))
                else
                    push!(search_paths, (vcat(current_path, c), contains_small))
                end
            end
        end
    end
    return found_paths
end
length(find_paths(data))