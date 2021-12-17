struct TargetReached end
struct TargetMissed end
struct TargetnotReached end
struct TargetOverShot end

struct Probe
    x::Vector{Int}
    v::Vector{Int}
end

function next_step!(p::Probe, (x1, x2, y1, y2))
    p.x[1] += p.v[1]
    p.x[2] += p.v[2]
    if p.v[1] < 0
        p.v[1] += 1
    elseif p.v[1] > 0
        p.v[1] -= 1
    end
    p.v[2] -= 1
    (x1 <= p.x[1] <= x2 && y1 <= p.x[2] <= y2) && return TargetReached
    (p.x[1] <= x2 && y1 <= p.x[2]) && return TargetnotReached
    return TargetMissed
end

function compute_trajectory(initial_velocity, target)
    trajectory = Dict(0=>[0,0])
    p = Probe([0,0], initial_velocity)
    i = 0
    while (state = next_step!(p, target)) == TargetnotReached
        i+=1
        trajectory[i] = copy(p.x)
    end
    return trajectory, state, p
end

inp = "target area: x=124..174, y=-123..-86"
target = parse.(Int,match(r"x=([-\d]+)..([-\d]+), y=([-\d]+)..([-\d]+)", inp).captures)

function sim_all_possible(target)
    max_height = 0
    all_valid = Set{Vector{Int}}()
    for vx in 1:target[2] # x velocity must be smaller than the distance to the target. Otherwise its overshot.
        for vy = -1000:1000
            trajectory, state, probe = compute_trajectory([vx,vy], target)
            if state == TargetMissed && probe.x[2] > target[3]
                break
            elseif state == TargetReached
                max_height = max(max_height, maximum(trajectory[k][2] for k in keys(trajectory)))
                push!(all_valid, [vx, vy])
            end
        end
    end
    return max_height, all_valid
end

part1, part2 = sim_all_possible(target)
length(part2)
