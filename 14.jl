function to_pairs(s)
    pairs = String[]
    for i = 1:length(s)-1
        push!(pairs, string(s[i], s[i+1]))
    end
    return pairs
end

function parse_input(file)
    data = readlines(file)
    temp = data[1]
    rules = split.(data[3:end], Ref(" -> "))
    template = split(temp, "")
    pairs = to_pairs(template)
    Dict(zip(pairs, ones(Int, length(pairs)))), Dict(rules), template
end

function do_replacements(pairs, rules)
    new_pairs = Dict{String,Int}()
    for p in keys(pairs)
        rep = rules[p]
        _pairs = to_pairs(string(p[1], rep, p[2]))
        for p_new in _pairs
            new_pairs[p_new] = get(new_pairs, p_new, 0) + pairs[p]
        end
    end
    return new_pairs
end

function get_stat(pairs, starting_template)
    unique_letters = Set(join(keys(pairs)))
    total = Dict(zip(unique_letters, zeros(Int, length(unique_letters))))
    for (p, v) in pairs
        for l in keys(total)
            if l == p[1]
                total[l] += v
            end
        end
    end
    total[starting_template[end][1]] += 1
    return total
end

# Part 1
pairs, rules, starting_template = parse_input("14.input")
for _ = 1:10
    pairs = do_replacements(pairs, rules)
end
st = get_stat(pairs, starting_template)
abs(-(extrema(values(st))...))

# Part 2
pairs, rules, starting_template = parse_input("14.input")
for _ = 1:40
    pairs = do_replacements(pairs, rules)
end
st = get_stat(pairs, starting_template)
abs(-(extrema(values(st))...))
