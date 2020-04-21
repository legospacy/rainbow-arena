-- Spatial hash implementation.
--
-- Reference:
-- http://www.gamedev.net/page/resources/_/technical/game-programming/spatial-hashing-r2697
--
-- Most logic from HC's spatial hash module:
-- https://github.com/vrld/HC/blob/master/spatialhash.lua


-- Module declaration --
local SpatialHash = {}
SpatialHash.__index = SpatialHash


-- Methods --
function SpatialHash:hash(x, y)
    return math.floor(x / self.cell_size), math.floor(y / self.cell_size)
end


function SpatialHash:get_cell(x, y)
    local row = rawget(self.cells, x)
    if not row then
        row = {}
        rawset(self.cells, x, row)
    end

    local cell = rawget(row, y)
    if not cell then
        cell = setmetatable({}, {__mode = "kv"})
        rawset(row, y, cell)
    end

    return cell
end


function SpatialHash:get_cell_containing_point(x, y)
    return self:get_cell(self:hash(x, y))
end


function SpatialHash:get_objects_in_aabb(x1, y1, x2, y2)
    local objs = {}

    x1, y1 = self:hash(x1, y1)
    x2, y2 = self:hash(x2, y2)

    for x = x1, x2 do
        for y = y1, y2 do
            for obj in pairs(self:get_cell(x, y)) do
                rawset(objs, obj, obj)
            end
        end
    end

    return objs
end


function SpatialHash:insert_object(obj, x1,y1, x2,y2)
    x1, y1 = self:hash(x1, y1)
    x2, y2 = self:hash(x2, y2)

    for x = x1, x2 do
        for y = y1, y2 do
            rawset(self:get_cell(x, y), obj, obj)
        end
    end
end


function SpatialHash:remove_object(obj, x1, y1, x2, y2)
    -- No AABB provided - go through all cells.
    if not (x1 and y1 and x2 and y2) then
        for _, row in pairs(self.cells) do
            for _, cell in pairs(row) do
                rawset(cell, obj, nil)
            end
        end

    else -- AABB provided - remove object from cells in that range only.
        x1,y1 = self:hash(x1,y1)
        x2,y2 = self:hash(x2,y2)

        for x = x1, x2 do
            for y = y1, y2 do
                rawset(self:get_cell(x, y), obj, nil)
            end
        end
    end
end


function SpatialHash:move_object(obj, old_x1,old_y1, old_x2,old_y2, new_x1,new_y1, new_x2,new_y2)
    old_x1,old_y1 = self:hash(old_x1,old_y1)
    old_x2,old_y2 = self:hash(old_x2,old_y2)

    new_x1,new_y1 = self:hash(new_x1,new_y1)
    new_x2,new_y2 = self:hash(new_x2,new_y2)

    if old_x1 == new_x1 and old_y1 == new_y1 and
        old_x2 == new_x2 and old_y2 == new_y2
    then return end

    for x = old_x1, old_x2 do
        for y = old_y1, old_y2 do
            rawset(self:get_cell(x, y), obj, nil)
        end
    end

    for x = new_x1, new_x2 do
        for y = new_y1, new_y2 do
            rawset(self:get_cell(x, y), obj, obj)
        end
    end
end


local function new(cell_size)
    return setmetatable({
        cell_size = cell_size or 100,
        cells = {}
    }, SpatialHash)
end


return {
    new = new
}
