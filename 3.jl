data = readlines("3-ex-a.input")
data = readlines("3.input")

binvec_to_dec(x) = parse(Int, join(x*1, ""), base=2)
parse_input_line(l) = parse.(Int,split(l,""))

# Part 1
gamma_rate = sum(parse_input_line.(data)).>length(data)/2
epsilon_rate = gamma_rate.==0
binvec_to_dec(gamma_rate)*binvec_to_dec(epsilon_rate)

# Part 2
most_common_oxy(data, idx) = Int(mapreduce(x->x[idx], +, data) >= length(data)/2)
most_common_co2(data, idx) = Int(!(mapreduce(x->x[idx], +, data) >= length(data)/2))
function filter_data(data, f)
    _data = parse_input_line.(data)
    for idx in 1:length(first(_data))
        mc = f(_data,idx)
        filter!(x->x[idx]==mc, _data)
        length(_data) == 1 && break
    end
    binvec_to_dec(only(_data))
end
filter_data(data, most_common_oxy)*filter_data(data, most_common_co2)


