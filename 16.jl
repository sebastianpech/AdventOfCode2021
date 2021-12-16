const mapping = Dict( "0" => "0000", "1" => "0001", "2" => "0010", "3" => "0011", "4" => "0100", "5" => "0101", "6" => "0110", "7" => "0111", "8" => "1000", "9" => "1001", "A" => "1010", "B" => "1011", "C" => "1100", "D" => "1101", "E" => "1110", "F" => "1111")

to_bin(x) = mapping[x]
bin_to_dec(x) = parse(Int, x, base=2)

struct Package{T}
    version::Int
    type::Int
    data::T
end

function read_Package(bin_data)
    version = bin_to_dec(bin_data[1:3])
    type = bin_to_dec(bin_data[4:6])
    if type == 4 # literal value
        data = String[]
        read_until = 0
        for pointer in 7:5:length(bin_data)
            push!(data, bin_data[pointer+1:pointer+4])
            read_until = pointer+4
            bin_data[pointer] == '0' && break
        end
        return Package(version, type, bin_to_dec(join(data))), read_until
    else # operator
        operator_type = bin_data[7]
        if operator_type == '0'
            bits_of_subpackages = bin_to_dec(bin_data[8:8+14])
            current_pointer = 8+15
            read_til = bits_of_subpackages + current_pointer
            data = Package[]
            while current_pointer < read_til
                p, read_until = read_Package(bin_data[current_pointer:read_til])
                current_pointer += read_until
                push!(data, p)
            end
            current_pointer != read_til && error("Current pointer not at the read_til mark.")
            return Package(version, type, data), read_til-1
        elseif operator_type == '1'
            number_of_packages = bin_to_dec(bin_data[8:8+10])
            current_pointer = 8+11
            data = Package[]
            for i in 1:number_of_packages
                p, read_until = read_Package(bin_data[current_pointer:end])
                current_pointer += read_until
                push!(data, p)
            end
            return Package(version, type, data), current_pointer-1
        else
            error("Wrong operator type")
        end
    end
end
parse_input(inp) = read_Package(join(to_bin.(split(inp,""))))
package,_ = parse_input(readline("16.input"))

# Part 1
compute_version_sum(p::Package{Int}) = p.version
compute_version_sum(p::Package{Vector{Package}}) = p.version + sum(compute_version_sum.(p.data))

compute_version_sum(package)

# Part 2
eval_package(p::Package) = eval_package(p, Val(p.type))
eval_package(p::Package{Int}, ::Any) = p.data
eval_package(p::Package{Vector{Package}}, ::Val{0}) = sum(eval_package.(p.data))
eval_package(p::Package{Vector{Package}}, ::Val{1}) = prod(eval_package.(p.data))
eval_package(p::Package{Vector{Package}}, ::Val{2}) = minimum(eval_package.(p.data))
eval_package(p::Package{Vector{Package}}, ::Val{3}) = maximum(eval_package.(p.data))
eval_package(p::Package{Vector{Package}}, ::Val{5}) = Int(eval_package(p.data[1]) > eval_package(p.data[2]))
eval_package(p::Package{Vector{Package}}, ::Val{6}) = Int(eval_package(p.data[1]) < eval_package(p.data[2]))
eval_package(p::Package{Vector{Package}}, ::Val{7}) = Int(eval_package(p.data[1]) == eval_package(p.data[2]))

eval_package(package)

