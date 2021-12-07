horizontal_positions = parse.(Int,split(read("7.input", String),","))

#Part 1
minimum(sum(abs.(horizontal_positions.-pos)) for pos in minimum(horizontal_positions):maximum(horizontal_positions))
#Part 2
minimum(mapreduce(n->n*(n+1)÷2, +, abs.(horizontal_positions.-pos)) for pos in minimum(horizontal_positions):maximum(horizontal_positions))
