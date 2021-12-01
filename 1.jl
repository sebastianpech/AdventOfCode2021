data = parse.(Int,readlines("1.input"))

# Part 1
count((data[2:end]-data[1:end-1]).>0)

# Part 2
avg = sum.(data[i:i+2] for i in 1:length(data)-2)
count((avg[2:end]-avg[1:end-1]).>0)