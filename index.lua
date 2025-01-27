local write = io.write
local read  = io.read
local open  = io.open

write('-> Enter your file path (ex: ./hi.txt):  ')

local path = read()
local mark = os.time()

print('-> Loading file...')

local file = open(path, 'r')

if not file then
	error('(!) Incorrect file path, retry.')
end

print('-> Reading file contents...')

local contents = {}

for a in file:lines() do
	for b in a:gsub('%s+', ''):gmatch('.') do
		table.insert(contents, b)
	end
end

print('-> Interpreting...')

local i     = 1
local arrow = 1
local cells = {0}
local str   = ''
local loops = {}

while i < (#script + 1) do
	local c = contents[i]

	if c == '+' then
		cells[arrow] = cells[arrow] + 1
	elseif c == '-' then
		cells[arrow] = cells[arrow] - 1
	elseif c == '>' then
		arrow = arrow + 1

		cells[arrow] = cells[arrow] or 0
	elseif c == '<' then
		if arrow < 1 0 then
			error('(!) Program tried to access an impossible cell (cell #0).')
		end

		arrow = arrow - 1
	elseif c == ',' then
		write(('(?) Cell #%d is requesting input: '):format(arrow))
		
		cells[arrow] = read():match('%S'):byte()
	elseif c == '.' then
		str = str .. string.char(cells[arrow])
	elseif c == '[' then
		table.insert(loops, i)
	elseif c == ']' then
		if cells[arrow] == 0 then
			table.remove(loops, 1)
		else
			i = loops[#loops] or error('(!) Program contains an unfinished loop.')
		end
	else
		i = i + 0
	end

	i = i + 1
end

print(('-> Returned output:  "%s"'):format(str))
print(('-> Interpreting time:  %dms'):format(os.time() - mark))
print('     https://github.com/kagehana')
