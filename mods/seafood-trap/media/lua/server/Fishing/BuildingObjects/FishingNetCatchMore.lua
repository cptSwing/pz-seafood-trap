require "Fishing/BuildingObjects/FishingNet.lua"

fishingNet.checkTrap = function(player, trap, hours)
    -- remove fishnet broken 
    local fishCaught = false;
--    if hours > 15 and ZombRand(5) == 0 then
--        getSoundManager():PlayWorldSound("getFish", false, player:getSquare(), 1, 20, 1, false)
--        player:playSound("CheckFishingNet");
--        trap:getSquare():transmitRemoveItemFromSquare(trap);
--        player:getInventory():AddItem("Base.BrokenFishingNet");
--        return;
--    end
    if hours > 20 then
        hours = 20;
    end
    -- 小饵鱼，淡水小龙虾，小虾，鱿鱼，牡蛎，大鳌虾
    local elements = {"Base.BaitFish", "Base.Crayfish", "Base.Shrimp", "Base.Squid", "Base.Oysters", "Base.Lobster"} ;
    local selected = {}; 
    local fish_count = ZombRand(2, 4);  

    for i = 1, fish_count do  
        local index = ZombRand(1, #elements);   
        table.insert(selected, elements[index]);   
        elements[index] = elements[#elements];  
        elements[#elements] = nil;  
    end
      
    local selectedElements = selected;
  
    for _, element in ipairs(selectedElements) do  
        for i=1,hours do
            local Fishnet_caught_count = ZombRand(4, 7);
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
