using LinearAlgebra
using Combinatorics
rotations = [[1,2,3], [1,3,2], [2,1,3], [2,3,1], [3,1,2], [3,2,1]]

orientations = [[1,1,1], [1,1,-1], [1,-1,1], [1,-1,-1], [-1,1,1], [-1,1,-1], [-1,-1,1], [-1,-1,-1]]
const all_states = collect(Base.product(rotations, orientations))[:]

struct Scanner
    beacons::Vector{Vector{Int}}
end

function to_scanner(d)
    Scanner(map(split.(split(d,"\n")[2:end],",")) do x
        parse.(Int,x)
    end)
end

beacon_location(s::Scanner, (base_coordinate, base_orientation), beacon_id) = [s.beacons[beacon_id][base_coordinate[1]]*base_orientation[1], s.beacons[beacon_id][base_coordinate[2]]*base_orientation[2], s.beacons[beacon_id][base_coordinate[3]]*base_orientation[3]]
transform(v, (base_coordinate, base_orientation)) = [v[base_coordinate[1]]*base_orientation[1], v[base_coordinate[2]]*base_orientation[2], v[base_coordinate[3]]*base_orientation[3]]

function beacon_to_beacon_distance(sc::Scanner)
    map(collect((Base.product(sc.beacons, sc.beacons)))) do x
        norm(x[1]-x[2])
    end
end

function get_reference_beacons(d1,d2)
    found_length = 0
    candidate = (0,0)
    for j in 1:size(d1,1)
        s1 = Set(d1[j,:])
        for i in 1:size(d2,1)
            s2 = Set(d2[i,:])
            s = intersect(s1,s2)
            if length(s) >= 12
                if length(s) > found_length
                # Found reference beacons j and i
                    candidate = (j,i)
                    found_length = length(s)
                end
            end
        end
    end
    return candidate
end
function get_beacon_mapping(d1,d2)
    rb1, rb2 = get_reference_beacons(d1,d2)
    mapping = Dict{Int, Int}()
    if rb1 != 0
        for (i,v) in enumerate(d1[rb1, :])
            idx = findfirst(x->v≈x, d2[rb2, :])
            if idx !== nothing
                mapping[i] = idx
            end
        end
    end
    return mapping
end

function get_relative_scanner_location(scanner_mappings, scanners, scanner_id, other_scanner_id, base_transformation)
    transformed_beacons = [transform(v,base_transformation) for v in scanners[scanner_id].beacons]
    for transformation in all_states
        distances = [transformed_beacons[idself]-beacon_location(scanners[other_scanner_id], transformation, idother) for (idself, idother) in scanner_mappings[scanner_id][other_scanner_id]]
        if length(Set(distances)) == 1
            return distances[1], transformation
        end
    end
    error("Not found $(scanner_id), $(other_scanner_id)")
end

function get_absolute_scanner_location(scanners, scanner_mappings)
    found_locations = Dict(1=>(x=[0,0,0], transformation=([1,2,3],[1,1,1])))
    use_base_location = Set([1])
    while length(use_base_location) > 0
        i = pop!(use_base_location)
        for j in 1:length(scanners)
            j in keys(found_locations) && continue
            length(scanner_mappings[i][j]) == 0 && continue
            location_rel_to_i, transformation = get_relative_scanner_location(scanner_mappings, scanners, i, j, found_locations[i].transformation)
            found_locations[j] = (x=location_rel_to_i+found_locations[i].x, transformation=transformation)
            push!(use_base_location, j)
        end
    end
    found_locations
end


function compute_all_beacon_locations(scanners, absolute_scanner_locations)
    beacons = Set{Vector{Int}}()
    for i in 1:length(scanners)
        beacon_locations = [transform(v,absolute_scanner_locations[i].transformation)+absolute_scanner_locations[i].x for v in scanners[i].beacons]
        union!(beacons, beacon_locations)
    end
    return beacons
end

scanners = to_scanner.(split(read("19.input", String),"\n\n"))
scanner_mappings = Dict{Int, Dict{Int, Dict{Int, Int}}}()
beacon_beacon_distances = Dict{Int, Matrix{Float64}}()
for (i,v) in enumerate(scanners)
    beacon_beacon_distances[i] = beacon_to_beacon_distance(v)
end
for i in 1:length(scanners)
    di = beacon_beacon_distances[i]
    scanner_mappings[i] = Dict{Int, Int}()
    for j in 1:length(scanners)
        i == j && continue
        dj = beacon_beacon_distances[j]
       scanner_mappings[i][j] = get_beacon_mapping(di,dj)
    end
end

absolute_scanner_locations = get_absolute_scanner_location(scanners, scanner_mappings)
compute_all_beacon_locations(scanners, absolute_scanner_locations)

# Part 2
xs = [p.x for p in values(absolute_scanner_locations)]

maximum(map(collect(Base.product(xs,xs))[:]) do (a,b)
    sum(a-b)
end)