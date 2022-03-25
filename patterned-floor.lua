-- This program builds a floor using a computercraft turtle with items and
-- variable input provided by the user. 


-- selects the next item, or the next specific item, in the turtle's inventory.
function next(item)
    if (item == nil) then
        for i=1, 16 do
            slot = turtle.getSelectedSlot()
            if (turtle.getItemDetail(slot) == nil) then
                if (slot == 16) then
                    turtle.select(1)
                else turtle.select(slot + 1) end
            else 
                break
            end
        end
    else
        for i=1, 16 do
            print("Finding " .. item .. "...")
            if (turtle.getItemDetail(i) ~= nil) then 
                print("Found an item!")
                if (turtle.getItemDetail(i).name == item) then
                    print("Found ".. item .. ".")
                    turtle.select(i)
                    break
                end
            end
        end
    end
end

-- finds the next item in the turtle's inventory and places it below the turtle
function place(item)
    next(item)
    print("Placing " .. turtle.getItemDetail().name .. "...")
    turtle.placeDown()
end

-- returns which item to place based on the counter and the pattern. returns a , b ; a= counter b= item

-- places a line of blocks with length len below the turtle; the turtle starts and ends on top of the line.
function line(len, pattern, counter)
    if (pattern == nil) then
        for j=1, len do
            place()
            if (j < len) then
                turtle.forward()
            end
        end
    else
        myCounter = counter
        for j=1, len do
            print("Counter = " .. myCounter .. ".")
            place(pattern[myCounter])
            myCounter = myCounter + 1
            if (myCounter > pattern.size) then myCounter = 1 end
            if (j < len) then
                turtle.forward()
            end
        end
        return myCounter
    end
end

-- moves the turtle right one block and faces opposite its starting position
function aroundRight()
    turtle.turnRight()
    turtle.forward()
    turtle.turnRight()
end

--moves the turtle left one block and faces opposite its starting position
function aroundLeft()
    turtle.turnLeft()
    turtle.forward()
    turtle.turnLeft()
end

-- places a floor of blocks with length len and width wid, and alternates blocks according to the table 'pattern'
function floor(len, wid, pattern)
    if (pattern == nil) then -- case for if the pattern is not given
        if (wid % 2 == 0) then
            for i=1, wid/2 do
                line(len)
                aroundRight()
                line(len)
                if (i < wid/2) then
                    aroundLeft()
                end
            end
        else 
            for i=1, wid/2 do
                line(len)
                aroundRight()
                line(len)
                aroundLeft()
                if (i == (wid-1)/2) then
                    line(len)
                end
            end
        end
    else -- case for if the pattern is given - WIP
        counter = 1
        if (wid % 2 == 0) then
            for i=1, wid/2 do
                counter = line(len, pattern, counter)
                aroundRight()
                counter = line(len, pattern, counter)
                if (i < wid/2) then
                    aroundLeft()
                end
            end
        else 
            for i=1, wid/2 do
                counter = line(len, pattern, counter)
                aroundRight()
                counter = line(len, pattern, counter)
                aroundLeft()
                if (i == (wid-1)/2) then
                    counter = line(len, pattern, counter)
                end
            end
        end
    end
end

-- makes a pattern, a 1D table, out of 1 to num slots of the turtle's inventory
function newPattern(num)
    pattern = {}
    if (num > 16) then num = 16 end
    for i=1, num do
        detail = turtle.getItemDetail(i)
        if (detail == nil) then
            error("Less items than pattern length provided")
        end
        pattern[i] = detail.name 
        print("storing " .. pattern[i] .. ".")
    end
    pattern.size = num
    return pattern
end

--prints out each item in a pattern
function printPattern(pattern)
    print("Printing pattern of size " .. pattern.size .. ":")
    for i=1, pattern.size do
        print(pattern[i])
    end
end

--clears terminal and brings cursor to the top left
function resetCur()
    term.clear()
    term.setCursorPos(1,1)
end

--gets user input to use for the program
function userInput()
    choice = ""
    length = ""
    width = ""
    slots = false
    repeat 
        resetCur()
        print("| Enter 0 for simple floor      |\n\n| Enter 1 for a patterned floor |")
        choice = io.read()
        choice = tonumber(choice)
        resetCur()
        print("| Now enter length of the floor |")
        length = io.read()
        length = tonumber(length)
        resetCur()
        print("| Now enter width of the floor |")
        width = io.read()
        width = tonumber(width)
        resetCur()
        if (choice == 1) then 
            print("| Now enter the number of slots in your pattern |")
            slots = io.read()
            slots = tonumber(slots)
            resetCur()
        end
    until (slots == false or slots < 17 and slots > 0)
    return choice, length, width, slots
end

--main program loop that runs everything else
function mainLoop()
    repeat
        exit = true
        myChoice, myLength, myWidth, mySlots = userInput()
        if (mySlots == false) then 
            floor(myLength, myWidth)
            print("Done!")
        else
            myPattern = newPattern(mySlots)
            floor(myLength, myWidth, myPattern)
            print("Done!")
        end
        print("Type 'again' to start the program over")
        myInput = io.read()
        exit = myInput == 'again'
    until (exit)


end

mainLoop()

--[[
testP = newPattern(16)
printPattern(testP)
floor(32,32,testP)
print("Done!")
--]]
