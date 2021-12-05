input_file = "4.input"
numbers_drawn = parse.(Int,split(readline(input_file),','))

numbers = split(read(input_file, String), "\n\n")

bingo_boards = map(numbers[2:end]) do l
    vcat(map(split(l,"\n")) do l
        parse.(Int,split(l, " ", keepempty=false))
    end'...)
end

function is_bingo(board, numbers)
    mask = map(x->x in numbers, board)
    sum_row = reduce(+, mask, dims=1)
    sum_col = reduce(+, mask, dims=2)
    if 5 in sum_row || 5 in sum_col 
        return mask
    end
    return nothing
end

function part01(bingo_boards, numbers_drawn)
    for (i,n) in enumerate(numbers_drawn)
        for b in bingo_boards
            bing = is_bingo(b, numbers_drawn[1:i])
            if bing !== nothing
                return sum(b[bing.==0])*n
            end
        end
    end
end
part01(bingo_boards, numbers_drawn)

function part02(bingo_boards, numbers_drawn)
    boards_won = [false for _ in 1:length(bingo_boards)]
    for (i,n) in enumerate(numbers_drawn)
        for (j,b) in enumerate(bingo_boards)
            if !(boards_won[j])
                bing = is_bingo(b, numbers_drawn[1:i])
                if bing !== nothing
                    boards_won[j] = true
                    if all(boards_won)
                        return sum(b[bing.==0])*n
                    end
                end
            end
        end
    end
end
part02(bingo_boards, numbers_drawn)

