function parse_data_line(l)
    inp, out = split.(split(l, " | "), Ref(" "))
    Set.(inp), Set.(out)
end
data = parse_data_line.(readlines("8.input"))
inp = (x->x[1]).(data)
out = (x->x[2]).(data)

# Part 1
const unique_combinations = Set([2, 4, 3, 7])

sum(map(out) do lo
    count((x->x in unique_combinations).(length.(lo)))
end)

# Part 2
function solve_data_line(l,o)
    lens = length.(l)
    idxs =  1:length(l)
    # 7 - 1 -> *a
    idx_7 = findfirst(==(3), lens)
    idx_1 = findfirst(==(2), lens)
    a = setdiff(l[idx_7],l[idx_1])
    # 4 + *a -> 9, because only 8 and 9 contain this combination and I know 8, thus I get *g
    idx_4 = findfirst(==(4), lens)
    idx_8 = findfirst(==(7), lens)
    t = union(l[idx_4],a)
    idx_9 = only(findall(x->x != idx_8 && issubset(t, l[x]), idxs))
    g = setdiff(l[idx_9], t)
    # 8 - 9 -> *e
    e = setdiff(l[idx_8],l[idx_9])
    # 7 + *e *g -> 0, because only 8 and 0 contain this comb. and I know 8
    t = union(l[idx_7], e, g)
    idx_0 = only(findall(x->x != idx_8 && issubset(t, l[x]), idxs))
    # 8-0 -> *d
    d = setdiff(l[idx_8], l[idx_0])
    # 8 - 7 - *e - *g - *d
    b = setdiff(l[idx_8], union(l[idx_7], e, g, d))
    # *a + *g + *d + *e -> is unique in 2, 8 and 6, but only 2 is of length 5
    t = union(a,g,d,e)
    idx_2 = only(findall(x->issubset(t, l[x]) && length(l[x]) == 5, idxs))
    # 2 - *a - *d - *g - *e -> *c
    c = setdiff(l[idx_2], t)
    # 1 - *c -> *f
    f = setdiff(l[idx_1], c)
    mapping = Dict(
        union(a,b,c,e,f,g) => 0,
        union(c,f) => 1,
        union(a,c,d,e,g) => 2,
        union(a,c,d,f,g) => 3,
        union(b,c,d,f) => 4,
        union(a,b,d,f,g) => 5,
        union(a,b,d,e,f,g) => 6,
        union(a,c,f) => 7,
        union(a,b,c,d,e,f,g) => 8,
        union(a,b,c,d,f,g) => 9,
    )
    mapped = map(x->mapping[x],o)
    mapreduce((a)->a[1]*10^a[2], +, zip(mapped, (length(mapped)-1):-1:0))
end

sum(solve_data_line.(inp, out))