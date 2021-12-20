const lopen = -1
const lclose = -2

to_number(n) = sum([v*10^(length(n)-i) for (i,v) in enumerate(n)])
function convert_input(sn)
    output = Int[]
    last_number = Int[]
    for v in collect(sn)
        if v == '['
            push!(output, lopen)
        elseif v == ']'
            length(last_number) > 0 && push!(output, to_number(last_number))
            last_number = Int[]
            push!(output, lclose)
        elseif v == ','
            length(last_number) > 0 && push!(output, to_number(last_number))
            last_number = Int[]
        else
            push!(last_number, parse(Int,v))
        end
    end
    return output
end

function print_sn(sn)
    str = ""
    for (i,v) in enumerate(sn)
        if v == lopen
            str*="["
        elseif v == lclose
            str*="]"
            if checkbounds(Bool, sn, i+1) && sn[i+1] != lclose
                str*=","
            end
        else
            str*=string(v)
            if checkbounds(Bool, sn, i+1) && sn[i+1] != lclose
                str*=","
            end
        end
    end
    return(str)
end

function get_layer_start(sn)
    layer = 0
    for (i,v) in enumerate(sn)
        if layer >= 5 && sn[i-1] == lopen
            # Check if it is an actual pair, eg the next numbers until ] are only allowed to be numbes
            for j in i:length(sn)
                if sn[j] == lopen
                    break
                elseif sn[j] == lclose
                    return i
                end
            end
        end
        if v == lopen
            layer += 1
        elseif v == lclose
            layer -= 1
        end
    end
    return -1
end
function explode!(sn)
    start_of_exploding = get_layer_start(sn)
    if start_of_exploding == -1
        return sn
    else
        end_of_pair = findnext(==(lclose), sn, start_of_exploding)
        a,b = sn[start_of_exploding:end_of_pair-1]
        # add to number on the left
        for i in start_of_exploding-1:-1:1
            if sn[i] != lopen && sn[i] != lclose
                sn[i] += a
                break
            end
        end
        # add to number on the right
        for i in start_of_exploding+2:length(sn)
            if sn[i] != lopen && sn[i] != lclose
                sn[i] += b
                break
            end
        end
        # Delete first number
        deleteat!(sn, start_of_exploding)
        # Replace second
        sn[start_of_exploding] = 0
        # Delete closing
        deleteat!(sn, start_of_exploding+1)
        # Delete opening
        deleteat!(sn, start_of_exploding-1)
    end
end

function split!(sn)
    n = findfirst(>(9), sn)
    no = sn[n]
    splice!(sn, n, [lopen, Int(floor(no/2)), Int(ceil(no/2)), lclose])
end

function reduce!(sn)
    first_explode = get_layer_start(sn)
    first_split = findfirst(>(9), sn)
    if first_explode == -1 && first_split === nothing
        return nothing
    end
    if first_explode != -1
        explode!(sn)
    elseif first_split !== nothing
        split!(sn)
    end
    reduce!(sn)
    nothing
end

function add_sn(a,b)
    sab = [lopen; a; b; lclose]
    reduce!(sab)
    return sab
end

function magnitude(sn)
    stru = eval(Meta.parse(print_sn(sn)))
    _magnitude(stru)
end
_magnitude(stru::Int) = stru
_magnitude(stru::Vector{<:Any}) = 3*_magnitude(stru[1])+2*_magnitude(stru[2])

# Part 1
data = convert_input.(readlines("19.input"))
sn = reduce(add_sn,data)

magnitude(sn)

# Part 2

max_mag = 0
for i in 1:length(data)
    for j in 1:length(data)
        i == j && continue
        sn = add_sn(data[i], data[j])
        max_mag = max(magnitude(sn), max_mag)
    end
end
max_mag