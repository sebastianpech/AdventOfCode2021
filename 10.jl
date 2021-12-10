data = readlines("10.input")

# Part 1

function get_corrupt(line)
    delimiters = Dict('{'=>'}', '['=>']', '('=>')', '<'=>'>')
    expecting = Char[]
    for d in line
        if d in keys(delimiters)
            push!(expecting,delimiters[d])
        else
            expecting[end] != d && return d
            pop!(expecting)
        end
    end
    return '0'
end

scores = Dict( ')' => 3, ']' => 57, '}' => 1197, '>' => 25137)
sum(get.(Ref(scores),get_corrupt.(data), Ref(0)))

# Part 2
using Statistics

function fix_incomplete(line)
    delimiters = Dict('{'=>'}', '['=>']', '('=>')', '<'=>'>')
    expecting = Char[]
    for d in line
        if d in keys(delimiters)
            push!(expecting,delimiters[d])
        else
            expecting[end] != d && return Char[]
            pop!(expecting)
        end
    end
    return reverse(expecting)
end
scores = Dict( ')' => 1, ']' => 2, '}' => 3, '>' => 4)

total_score(l) = foldl((a,b)->scores[b]+a*5,l, init=0)
Int(median(filter(!(==(0)),total_score.(fix_incomplete.(data)))))
