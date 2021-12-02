data = readlines("2.input")

function parse_commands(l)
    command, _value = split(l, ' ')
    value = parse(Int, _value)
    if command == "forward"
        return value
    elseif command == "down"
        return value*1im
    else
        return value*-1im
    end
end

# Part 1
x = mapreduce(parse_commands,+,data)
real(x)*imag(x)

# Part 2
x = reduce(map(parse_commands,data),init=(complex(0), 0)) do a, b
    Δ = (a[2]+imag(b)*1im)
    (a[1]+real(b)+Δ*real(b), Δ)
end

real(x[1])*imag(x[1])