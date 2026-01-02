local RESOURCE_NAME = GetCurrentResourceName()
local fw = exports['Az-Framework']  

Config = Config or {}
if Config.Debug == nil then Config.Debug = true end  


local function debugPrint(...)
    if not Config.Debug then return end
    local args = { ... }
    for i = 1, #args do
        args[i] = tostring(args[i])
    end
    print(("^3[%s]^7 %s"):format(RESOURCE_NAME, table.concat(args, " ")))
end


AddEventHandler('onResourceStart', function(res)
    if res ~= RESOURCE_NAME then return end
    debugPrint("Resource started, checking Az-Framework exports...")

    if not fw then
        debugPrint("fw == nil (exports['Az-Framework'] missing?)")
    else
        debugPrint("fw handle OK:", tostring(fw))
        debugPrint("Has GetPlayerMoney?", fw.GetPlayerMoney and "yes" or "no")
        debugPrint("Has deductMoney?", fw.deductMoney and "yes" or "no")
    end
end)





local function getDealership(id)
    if not Config.Dealerships then
        debugPrint("Config.Dealerships is nil!")
        return nil
    end
    local d = Config.Dealerships[id]
    if not d then
        debugPrint("getDealership: dealership", id, "NOT found in Config.Dealerships")
    else
        debugPrint("getDealership: found dealership", id, "label:", d.label or "N/A")
    end
    return d
end

local function getVehicleConfig(dealerId, vehicleId)
    local d = getDealership(dealerId)
    if not d then
        debugPrint("getVehicleConfig: no dealership for id", dealerId)
        return nil
    end

    if not d.stock or #d.stock == 0 then
        debugPrint("getVehicleConfig: dealership", dealerId, "has NO stock table")
        return nil
    end

    for idx, v in ipairs(d.stock) do
        if v.id == vehicleId then
            debugPrint("getVehicleConfig: found vehicle", vehicleId, "in dealer", dealerId, "at index", idx)
            return v
        end
    end

    debugPrint("getVehicleConfig: vehicleId", vehicleId, "NOT found in dealer", dealerId, "stock")
    return nil
end





local function chargePlayer(src, price)
    price = tonumber(price) or 0
    debugPrint("chargePlayer: src", src, "price", price)

    if price <= 0 then
        debugPrint("chargePlayer: price <= 0, nothing to deduct.")
        return
    end

    if not fw then
        debugPrint("chargePlayer: fw is nil, cannot deductMoney – NOT charging.")
        return
    end

    if not fw.deductMoney then
        debugPrint("chargePlayer: fw.deductMoney is nil, NOT charging.")
        return
    end

    local ok, err = pcall(function()
        fw:deductMoney(src, price)  
    end)

    if not ok then
        debugPrint("Error calling fw:deductMoney for src", src, "price", price, "err:", err)
    else
        debugPrint("chargePlayer: fw:deductMoney called successfully.")
    end
end





local function handlePurchase(src, dealerId, vehicleId, colorName)
    debugPrint("handlePurchase: src", src, "dealerId", dealerId, "vehicleId", vehicleId, "color", colorName or "nil")

    local dealership = getDealership(dealerId)
    if not dealership then
        debugPrint("handlePurchase: dealership NOT found, aborting.")
        TriggerClientEvent("apx-legendary:purchaseResult", src, false, "Dealer not found.")
        return
    end

    local vCfg = getVehicleConfig(dealerId, vehicleId)
    if not vCfg then
        debugPrint("handlePurchase: vehicle config NOT found for vehicleId", vehicleId, "dealerId", dealerId)
        TriggerClientEvent("apx-legendary:purchaseResult", src, false, "Vehicle not found.")
        return
    end

    local price = tonumber(vCfg.price) or 0
    if price < 0 then price = 0 end
    debugPrint("handlePurchase: resolved price =", price, "for", vCfg.name or vCfg.model or "vehicle")

    
    local function finalizePurchase()
        debugPrint("finalizePurchase: src", src, "dealerId", dealerId, "vehicleId", vehicleId, "price", price)

        chargePlayer(src, price)

        debugPrint("finalizePurchase: TriggerClientEvent spawnPurchasedVehicle -> dealerId", dealerId, "model", vCfg.model, "color", colorName or "nil")
        TriggerClientEvent("apx-legendary:spawnPurchasedVehicle", src, dealerId, vCfg.model, colorName)

        debugPrint("finalizePurchase: TriggerClientEvent purchaseResult SUCCESS")
        TriggerClientEvent("apx-legendary:purchaseResult", src, true,
            string.format("You bought a %s for $%s!", vCfg.name or vCfg.model or "vehicle", price))
    end

    
    if price <= 0 then
        debugPrint("handlePurchase: price <= 0, skipping money check, proceeding to spawn.")
        finalizePurchase()
        return
    end

    
    if not fw or not fw.GetPlayerMoney then
        debugPrint("handlePurchase: fw or fw.GetPlayerMoney is nil, ALLOWING purchase and spawning anyway.")
        finalizePurchase()
        return
    end

    
    
    
    local finished = false

    local function done(ok, reason, wallet)
        if finished then return end
        finished = true

        if not ok then
            debugPrint("handlePurchase: money check FAILED for src", src, "reason:", reason or "nil")
            TriggerClientEvent("apx-legendary:purchaseResult", src, false,
                reason or "We couldn't check your funds. Try again.")
            return
        end

        if wallet then
            debugPrint(("handlePurchase: money check OK, cash=%s bank=%s price=%s"):format(
                tostring(wallet.cash or 0),
                tostring(wallet.bank or 0),
                tostring(price)
            ))
        else
            debugPrint("handlePurchase: money check OK (no wallet table passed).")
        end

        finalizePurchase()
    end

    debugPrint("handlePurchase: calling fw:GetPlayerMoney for src", src)

    
    local ok, errMsg = pcall(function()
        fw:GetPlayerMoney(src, function(err, wallet)
            debugPrint("GetPlayerMoney callback fired for src", src, "err =", err or "nil")

            if err then
                
                done(false, ("Money error: %s"):format(tostring(err)), wallet)
                return
            end

            wallet = wallet or {}
            local cash = tonumber(wallet.cash or 0) or 0
            local bank = tonumber(wallet.bank or 0) or 0
            debugPrint("GetPlayerMoney result: src", src, "cash =", cash, "bank =", bank, "price =", price)

            if cash < price then
                done(false, "You don't have enough cash.", wallet)
                return
            end

            done(true, nil, wallet)
        end)
    end)

    if not ok then
        debugPrint("handlePurchase: pcall around fw:GetPlayerMoney FAILED:", errMsg)
        done(false, "Internal error checking your funds.")
    else
        debugPrint("handlePurchase: fw:GetPlayerMoney called successfully (awaiting callback).")
    end

    
    SetTimeout(1500, function()
        if finished then return end
        debugPrint("handlePurchase: GetPlayerMoney TIMEOUT for src", src,
            "- allowing purchase WITHOUT money check (check Az-Framework GetPlayerMoney).")
        done(true, "timeout_fallback", nil)
    end)
end





RegisterNetEvent("apx-legendary:buyFromNui", function(dealerId, vehicleId, colorName)
    local src = source
    debugPrint("EVENT apx-legendary:buyFromNui fired. src", src, "dealerId", dealerId, "vehicleId", vehicleId, "colorName", colorName or "nil")
    handlePurchase(src, dealerId, vehicleId, colorName)
end)

RegisterNetEvent("apx-legendary:buyFromLot", function(dealerId, vehicleId)
    local src = source
    debugPrint("EVENT apx-legendary:buyFromLot fired. src", src, "dealerId", dealerId, "vehicleId", vehicleId)
    handlePurchase(src, dealerId, vehicleId, nil)
end)


AddEventHandler('onResourceStop', function(res)
    if res ~= RESOURCE_NAME then return end
    debugPrint("Resource stopping, server.lua cleanup complete.")
end)
