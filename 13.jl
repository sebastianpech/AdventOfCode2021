function parse_input(file)
    l = readlines(file)
    idx_sep = findfirst(==(""), l)
    markers = (x->Tuple(parse.(Int,x))).(split.(l[1:idx_sep-1],','))
    folds = (x->(let isx =endswith(x[1],"x")
        if isx
            return :x, parse(Int, x[2])
        else
            return :y, parse(Int, x[2])
        end
    end)).(split.(l[idx_sep+1:end],'='))
    markers, folds
end

function print_data(data)
    xs = (x->x[1]).(data)
    ys = (x->x[2]).(data)
    x_min, x_max = extrema(xs)
    y_min, y_max = extrema(ys)
    for y in y_min:y_max
        for x in x_min:x_max
            if (x,y) in data
                print("#")
            else
                print(" ")
            end
        end
        println()
    end
end

mirror(data, fold::Tuple) = collect(Set(mirror(data, fold[2], Val(fold[1]))))
function mirror(data, axis, ::Val{:x})
    map(data) do (x,y)
        if x > axis
            return (2*axis - x, y)
        else
            return (x, y)
        end
    end
end
function mirror(data, axis, ::Val{:y})
    map(data) do (x,y)
        if y > axis
            return (x, 2*axis - y)
        else
            return (x, y)
        end
    end
end

markers, folds = parse_input("13.input")
markers = mirror(markers, folds[1])
length(markers)


markers, folds = parse_input("13.input")
for f in folds
    markers = mirror(markers, f)
end

print_data(markers)