require "Fishing/BuildingObjects/FishingNet.lua"

fishingNet.checkTrap = function(player, trap, hours)
    local fishCaught = false;
    local cappedHours = hours;
    local slidingChance = 12;
    -- the fishnet can broke !

    if hours > 24 then
        local breakChance = ZombRand(slidingChance);
        print("breakChance: ", breakChance);
        if breakChance == 0 then
            -- getSoundManager():PlayWorldSound("getFish", false, player:getSquare(), 1, 20, 1, false)
            player:playSound("CheckFishingNet");
            trap:getSquare():transmitRemoveItemFromSquare(trap);
            player:getInventory():AddItem("Base.BrokenFishingNet");
            print("Fishing net broken!");
            return;
        end

        cappedHours = 24;
    end

    local elements = {
        "Base.BaitFish", "Base.Crayfish", "Base.Shrimp", "Base.Oysters"
    };
    local selected = {};
    local numFishTypes = ZombRand(1, 3);

    local maxFishCountPerType = {
        ["Base.BaitFish"] = {min = 1, max = 3, currentTotal = 0},
        ["Base.Crayfish"] = {min = 2, max = 4, currentTotal = 0},
        ["Base.Shrimp"] = {min = 1, max = 3, currentTotal = 0},
        ["Base.Oysters"] = {min = 2, max = 5, currentTotal = 0}
    };

    for i = 1, numFishTypes do
        local index = ZombRand(1, #elements);
        table.insert(selected, elements[index]);

        print("Adding possible Fish type: ", elements[index]);

        elements[index] = elements[#elements];
        elements[#elements] = nil;
    end

    print("hours: ", hours, " / cappedHours: ", cappedHours,
          " / numFishTypes: ", numFishTypes, " / trap: ", trap);

    local selectedElements = selected;

    for _, element in ipairs(selectedElements) do
        for i = 1, cappedHours do
            local Fishnet_caught_factor = ZombRand(slidingChance * 2);

            local furtherRand = ZombRand(Fishnet_caught_factor);
            print("i: ", i, " / Fishnet_caught_factor: ", Fishnet_caught_factor);

            if Fishnet_caught_factor == 0 then
                local minCount = maxFishCountPerType[element]["min"];
                local maxCount = maxFishCountPerType[element]["max"];
                print(minCount, " / ", maxCount);
                local addCount = ZombRand(minCount, maxCount);

                for i = 1, addCount do
                    if maxFishCountPerType[element]["currentTotal"] < maxCount then
                        player:getInventory():AddItem(element);
                        maxFishCountPerType[element]["currentTotal"] =
                            maxFishCountPerType[element]["currentTotal"] + 1;
                    end
                end
                print("i: ", i, " / Added ", addCount, " of caught element: ",
                      element);

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
