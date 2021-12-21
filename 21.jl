# Part 1
function new_deterministic_dice(go_til::Int) 
    dice_value = 0
    count_rolls = 0
    return function ()
        count_rolls += 1
        return dice_value = mod1(dice_value+1, go_til)
    end, ()->count_rolls
end

player_position = [8, 2]
player_score = [0, 0]
dice, get_rolls = new_deterministic_dice(100)
player = 1
while all(<(1000), player_score)
    player_position[player] = mod1(player_position[player]+dice()+dice()+dice(), 10)
    player_score[player] += player_position[player]
    player = mod1(player+1, 2)
end

minimum(player_score)*get_rolls()

# Part 2

function new_deterministic_dice(go_til::Int) 
    dice_value = 0
    count_rolls = 0
    return function ()
        count_rolls += 1
        return dice_value = mod1(dice_value+1, go_til)
    end, ()->count_rolls
end

player_position = [8, 2]
player_score = [0, 0]
dice, get_rolls = new_deterministic_dice(100)
player = 1
while all(<(1000), player_score)
    player_position[player] = mod1(player_position[player]+dice()+dice()+dice(), 10)
    player_score[player] += player_position[player]
    player = mod1(player+1, 2)
end

minimum(player_score)*get_rolls()

# Part 2

struct State
    position::Tuple{Int,Int}
    scores::Tuple{Int, Int}
end
struct History{N}
    throws::NTuple{N, Int}
    multiplier::Int
end
function move_state(s::State, i, player)
    pn = mod1(s.position[player]+i, 10)
    sn = s.scores[player] + pn
    if player == 1
        return State((pn, s.position[2]),(sn,s.scores[2]))
    end
    return State((s.position[1], pn),(s.scores[1], sn))
end

possible_throws = sum.(collect(Base.product((1,2,3),(1,2,3),(1,2,3)))[:])

const throw_number = Dict(t=>count(==(t), possible_throws) for t in Set(possible_throws))

function do_step(state::Dict{History{N}, State}, win_counter) where N
    new_state = Dict{History{N+1}, State}()
    player = mod1(N,2)
    for (hist, st) in state
        for (t,m) in throw_number
            ns = move_state(st, t, player)
            if ns.scores[1] >= 21 || ns.scores[2] >= 21
                if ns.scores[1] >= 21
                    win_counter[1] += hist.multiplier*m
                else
                    win_counter[2] += hist.multiplier*m
                end
            else
                new_state[History((hist.throws..., t),hist.multiplier*m)] = ns
            end
        end
    end
    new_state
end

win_counter = Int[0, 0]
state = Dict(History((0,), 1)=>State((8,2), (0,0)))
while length(state) > 0
    state = do_step(state, win_counter)
end

maximum(win_counter)