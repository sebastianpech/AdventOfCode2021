function parse_input_data(file)
    enh_algo, image = split(read(file, String), "\n\n")
    sp = split(image,"\n")
    d = Dict{Tuple{Int, Int}, Bool}()
    for i in 1:length(sp)
        for j in 1:length(sp[i])
            d[(i,j)] = sp[i][j] == '#'
        end
    end
    split(enh_algo,"") .== "#", d
end

function print_image(img)
    i_min, i_max = extrema((x->x[1]).(keys(img)))
    j_min, j_max = extrema((x->x[2]).(keys(img)))
    for i in i_min:i_max
        for j in j_min:j_max
            if img[(i,j)]
                print("#")
            else
                print(".")
            end
        end
        println()
    end
end

const Δij = [(-1,-1), (-1,0), (-1, 1), (0, -1), (0, 0), (0, 1), (1, -1), (1, 0), (1, 1)]

function perform_transformation(enh_algo, img, itr)
    i_min, i_max = extrema((x->x[1]).(keys(img)))
    j_min, j_max = extrema((x->x[2]).(keys(img)))
    output_image = Dict{Tuple{Int, Int}, Bool}()
    for i in i_min-1:i_max+1
        for j in j_min-1:j_max+1
            entry = (i,j)
            loc = parse(Int, join([Int(get(img, entry.+Δ, itr%2 == 0)) for Δ in Δij], ""),base=2)+1
            output_image[entry] = enh_algo[loc]
        end
    end
    return output_image
end

# Part 1

enh_algo, img = parse_input_data("20.input")
img_out = copy(img)
for i in 1:2
    img_out = perform_transformation(enh_algo, img_out, i)
end
count(values(img_out))

# Part 2

enh_algo, img = parse_input_data("20.input")
img_out = copy(img)
for i in 1:50
    img_out = perform_transformation(enh_algo, img_out, i)
end
count(values(img_out))