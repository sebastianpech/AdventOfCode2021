data = parse.(Int,split(read("6.input", String),","))
function simulate(init, N_days )
    last_day = Dict([i=>count(==(i), init) for i in 0:8])
    for day in 1:N_days
        next_day = Dict{Int,Int}()
        next_day[8] = last_day[0]
        for i in 1:8
            next_day[i-1] = last_day[i]
        end
        next_day[6] += last_day[0]
        last_day = next_day
    end
    return sum(values(last_day))
end

# Part 1
simulate(data, 80)

# Part 2
simulate(data, 256)