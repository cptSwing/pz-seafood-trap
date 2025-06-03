require "Fishing/BuildingObjects/FishingNet.lua"

fishingNet.checkTrap = function(player, trap, hours)
    -- the fishnet can broke !
    local fishCaught = false;

    if hours > 20 then
        if ZombRand(20) == 0 then
            -- getSoundManager():PlayWorldSound("getFish", false, player:getSquare(), 1, 20, 1, false)
            player:playSound("CheckFishingNet");
            trap:getSquare():transmitRemoveItemFromSquare(trap);
            player:getInventory():AddItem("Base.BrokenFishingNet");
            return;
        end

        hours = 20;
    end
    local elements = {
        "Base.BaitFish", "Base.Crayfish", "Base.Shrimp", "Base.Oysters"
    };
    local selected = {};
    -- random integer [1,3]
    local fish_count = ZombRand(1, 4);

    for i = 1, fish_count do
        local index = ZombRand(1, #elements);
        table.insert(selected, elements[index]);
        elements[index] = elements[#elements];
        elements[#elements] = nil;
    end

    local selectedElements = selected;

    for _, element in ipairs(selectedElements) do
        for i = 1, hours do
            local Fishnet_caught_count = ZombRand(5, 10);
            if ZombRand(Fishnet_caught_count) == 0 then
                player:getInventory():AddItem(element);
                fishCaught = true;
            end
        end
    end

    if fishCaught then
        fishCaught = false;
        player:getXp():AddXP(Perks.Fishing, 1);
    end
    fishingNet.doTimestamp(trap);
end
