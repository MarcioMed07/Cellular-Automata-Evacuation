require 'math'
function print_universe(automatas)
    for i=1,universe_size do
        for j=1,universe_size do
			if automatas[i][j].state == 1 then
				io.write('i ')
			elseif automatas[i][j].state == 2 then
				io.write('O ')
			else
				io.write('  ')
			end
        end
        print(' ')
    end
    print('left: '..count_alive(automatas)) 
	os.execute("sleep 0.01")  
	if not os.execute("cls")  then
		os.execute("clear")
	end
end

function count_alive(automatas)
	count = 0
	for i = 1, universe_size do
		for j = 1, universe_size do
			if automatas[i][j].state == 1 then
				count = count + 1
			end
		end
	end
	return count
end


function plan_move(automatas,i,j)
	if automatas[i][j] == 2 then return 2 end
	
	if automatas[i][j].state == 1 then 
		
		if i > door.x and automatas[i-1][j].state == 0 and automatas[i-1][j].new_state == 0 then
			automatas[i-1][j].new_state = 1
			return 0
		end
		
		if i < door.x and automatas[i+1][j].state == 0 and automatas[i+1][j].new_state == 0 then
			automatas[i+1][j].new_state = 1
			return 0
		end
		
		if j > door.y and automatas[i][j-1].state == 0 and automatas[i][j-1].new_state == 0 then
			automatas[i][j-1].new_state = 1
			return 0
		end
		
		if j < door.y and automatas[i][j+1].state == 0 and automatas[i][j+1].new_state == 0 then
			automatas[i][j+1].new_state = 1
			return 0
		end
		
		if j==door.y and i==door.x then
			return 0
		end
		return 1 
	end
	
	return 0
end
function move(automatas) 
	for i = 1, universe_size do
		for j = 1, universe_size do
			automatas[i][j].state = automatas[i][j].new_state
		end
	end
end

function create_automata(state)
	return {state = state, new_state=state}
end

function generate_door()
	side = math.random(1,4)
	if side == 1 then
		x = 1
		y = math.random(2,universe_size-1)
	elseif side == 2 then
		x = universe_size
		y = math.random(2,universe_size-1)
	elseif side == 3 then
		x = math.random(2,universe_size-1)
		y = 1
	else
		x = math.random(2,universe_size-1)
		y = universe_size
	end

	return {x=x,y=y}
end

--start--

universe_size = 25
automatas = {}
N = 100
math.randomseed(os.time())
if N > (universe_size-2)^2 then
	print("More people than rooms capacity!")
	os.exit()
end
door = generate_door()
for i = 1, universe_size do
    automatas[i] = {}
    for j = 1, universe_size do
		if i == 1 or i == universe_size or j == 1 or j == universe_size then
			if i == door.x and j == door.y then
				automatas[i][j] = create_automata(0) -- Build Door
			else
				automatas[i][j] = create_automata(2) -- Build walls
			end
		else
			automatas[i][j] = create_automata(0) -- Build floor	
		end
		
    end
end

--Initial states
while N > count_alive(automatas) do
	automatas[math.random(2,universe_size-1)][math.random(2,universe_size-1)] = create_automata(1) -- Drop N people ate random location
end
moves = 0
--simulate universe
while count_alive(automatas) > 0 do
	for i=1,universe_size do 
		for j=1,universe_size do
			if automatas[i][j].state == 1 then
				automatas[i][j].new_state = plan_move(automatas,i,j)
			end
		end
	end
	move(automatas)
	moves = moves + 1
	print_universe(automatas)
end
print("EVACUETED!\nMoves: "..moves)
