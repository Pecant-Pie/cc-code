
-- searches for an item and returns true and selects it. If not given an index
-- it will start from the currently selected slot.
function findItem(name, index) 
    if (index == nil || index > 16 || index < 1) then
        index = turlte.getSelectedSlot()
    end
    for index, 16 do
        turtle.select(i)
        if (turtle.getItemDetail().name == name) then
            return true
        end
    return false
end

-- selects the last empty slot in its inventory
function lastEmpty()
    for i=16, 1, -1 do
        if (not turtle.getItemDetail()) then
            return true
        end
    end
    return false
end

-- WIP
function newRecipe()

-- Clears... (WIP)
function clearCraft(count)
    for i=4, 12, 4 do
        turtle.select(i)
        turtle.drop()
    end
    for i=13, 16 do
        turtle.select(i)
        turtle.drop()
    end
    turtle.craft(count)
end

-- searches for an item and moves it to the given slot. If no slot is 
-- given it will move it to the slot selected at the start of the function call.
function itemTo(name, amount, slot)
    if (amount == nil) then 
        amount = 1
    end
    if (slot == nil || slot < 1 || slot > 16) then
        slot = turtle.getSelectedSlot()
    end
    if (findItem(name)) then
        if (amount < 0 || amount > turtle.getItemCount()) then
            return turtle.transferTo(slot)
        else
            return turtle.transferTo(slot, amount)
        end
    end
    return false
end

-- converts the i and j position in a 3x3 table to the corresponding
-- slot in the top left of the turtle's inventory.
function posToSlot(i, j)   
    tbl = {{1,2,3},{5,6,7},{9,10,11}}
    return tbl[i][j]
end

-- adds the given 3x3 recipe table into the recipes folder as a new file,
-- with filename recipeName. Returns false if there was already
-- a file with the same name, returns true if not.
function saveRecipe(recipe, recipeName) 
    if (not fs.exists("recipes/" .. recipeName)) then
        local file = fs.open("recipes/" .. recipeName, "w")
        for i=1,3 do
            str = ""
            for j=1,3 do
                str = str .. "{" .. recipe[i][j] .. "}"
            end
            file.writeLine(str)
        end
        file.close()
        return true
    else return false
end


-- adds the given 3x3 recipe table into the recipes folder as a new file,
-- with filename recipeName. Returns false if there was already
-- a file with the same name, returns true if not.
function saveRecipeFORMAT(recipe, recipeName)  --ALTERED FUNCTION USING String.format()
    if (not fs.exists("recipes/" .. recipeName)) then
        local file = fs.open("recipes/" .. recipeName, "w")
        for i=1,3 do
            str = ""
            for j=1,3 do
                str = ("%s{%s}"):format(str, recipe[i][j])
                --str = str .. "{" .. recipe[i][j] .. "}" (replaced by prev line)
            end
            file.writeLine(str)
        end
        file.close()
        return true
    else return false
end


-- returns the table from the file with name recipeName
function loadRecipe(recipeName)
    local tbl = {}
    if (fs.exists("recipes/" .. recipeName)) then
        local file = fs.open("recipes/" .. recipeName, "r")
        for i=1,3 do
            line = file.readLine()
            tbl[i][1], tbl[i][2], tbl[i][3] = entryGrab(line)
        end
        return tbl
    else return false
end


-- returns a table with the total materials for a recipe
function totalMats(recipe) 
    --returns the index at which name occurs 
    function matsIndex(mats, name)
        for ind, item, in ipairs(mats) do
            if (item.name ~= nil and item.name == name) then
                return ind
            end
        end
        return nil
    end

    local mats = {}
    mats.length = 0
    for i=1, 3 do
        for j=1, 3 do
            str = recipe[i][j]
            ind = matsIndex(mats, str)
            if (ind) then
                mats[ind].count++
            else
                mats.length++
                mats[mats.length].name = str
                mats[mats.length].count = 1
            end
        end
    end
    return mats
end


-- returns three entries from a string separated by {} as 
-- 3 different strings
function entryGrab(str, index)
    local tbl = {}
    if (index == nil) then
        index = 1
    end
    for i=1, 3 do
        strStart =  string.find(str, "{", index)
        strEnd = string.find(str, "}", index)
        tbl[i] = string.sub(str, strStart, strEnd - strStart)
        index = strEnd+1
    end
    return tbl[1], tbl[2], tbl[3]
end


--helper function that determines if a certain entry is contained within a table
function contains(tbl, entry)
    for ind, item in ipairs(tbl) do
        if (item == entry) then
            return true
        end
    end
    return false
end

