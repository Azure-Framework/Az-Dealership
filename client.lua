local RESOURCE_NAME = GetCurrentResourceName()

local isUiOpen = false
local spawnedPeds = {}
local lotVehicles = {}

local function debugPrint(...)
    if not Config.Debug then
        return
    end
    local args = {...}
    for i = 1, #args do
        args[i] = tostring(args[i])
    end
    print(("^3[%s]^7 %s"):format(RESOURCE_NAME, table.concat(args, " ")))
end

local function loadModel(model)
    local hash = (type(model) == "number") and model or joaat(model)
    if not HasModelLoaded(hash) then
        RequestModel(hash)
        local t = 0
        while not HasModelLoaded(hash) and t < 100 do
            Wait(50)
            t = t + 1
        end
    end
    return hash
end

local function showHelpText(msg)
    BeginTextCommandDisplayHelp("STRING")
    AddTextComponentSubstringPlayerName(msg)
    EndTextCommandDisplayHelp(0, false, true, -1)
end

local function drawFloatingText(coords, text)
    local onScreen, _x, _y = World3dToScreen2d(coords.x, coords.y, coords.z)
    if onScreen then
        SetTextScale(0.32, 0.32)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 230)
        SetTextCentre(1)
        BeginTextCommandDisplayText("STRING")
        AddTextComponentSubstringPlayerName(text)
        EndTextCommandDisplayText(_x, _y)
    end
end

local function formatMoney(num)
    local left, num, right = string.match(tostring(num), "^([^%d]*%d)(%d*)(.-)$")
    return left .. (num:reverse():gsub("(%d%d%d)", "%1,"):reverse()) .. right
end

local function debugDumpStock(id, dealership)
    if not Config.Debug then
        return
    end
    debugPrint("Dumping stock for dealership:", id)
    for i, v in ipairs(dealership.stock or {}) do
        debugPrint(
            ("  [%d] id=%s model=%s price=%s imageUrl=%s"):format(
                i,
                v.id or "nil",
                v.model or "nil",
                v.price or "nil",
                v.imageUrl or "nil"
            )
        )
    end
end

local function openDealershipUi(id)
    if isUiOpen then
        debugPrint("openDealershipUi called but UI already open, id:", id)
        return
    end

    local dealership = Config.Dealerships[id]
    if not dealership then
        debugPrint("openDealershipUi: no dealership with id", id)
        return
    end

    debugDumpStock(id, dealership)

    local stock = {}
    for _, v in ipairs(dealership.stock or {}) do
        stock[#stock + 1] = {
            id = v.id,
            model = v.model,
            name = v.name,
            price = v.price,
            category = v.category or "featured",
            imageUrl = v.imageUrl or "",
            stats = v.stats or {},
            colors = v.colors or {},
            blurb = v.blurb or ""
        }
    end

    SetNuiFocus(true, true)
    isUiOpen = true

    debugPrint("Sending NUI openShop with", #stock, "vehicles for", id)

    SendNUIMessage(
        {
            action = "openShop",
            dealership = {
                id = id,
                label = dealership.label or "Premium Dealership",
                stock = stock
            }
        }
    )
end

RegisterNUICallback(
    "close",
    function(_, cb)
        SetNuiFocus(false, false)
        isUiOpen = false
        debugPrint("NUI close callback triggered")
        cb({})
    end
)

RegisterNUICallback(
    "buyVehicle",
    function(data, cb)
        local dealerId = data.dealershipId
        local vehicleId = data.vehicleId
        local colorName = data.colorName

        debugPrint("NUI buyVehicle", dealerId, vehicleId, colorName or "none")
        TriggerServerEvent("apx-legendary:buyFromNui", dealerId, vehicleId, colorName)
        cb({})
    end
)

RegisterNetEvent(
    "apx-legendary:spawnPurchasedVehicle",
    function(dealerId, model, colorName)
        debugPrint("spawnPurchasedVehicle event for", dealerId, model, colorName or "noColor")

        SendNUIMessage({action = "closeShop"})
        SetNuiFocus(false, false)
        isUiOpen = false

        local dealership = Config.Dealerships[dealerId]
        if not dealership then
            debugPrint("spawnPurchasedVehicle invalid dealer", dealerId)
            return
        end

        local spawns = dealership.purchaseSpawns or {}
        local spawn = spawns[1]

        for _, s in ipairs(spawns) do
            if not IsAnyVehicleNearPoint(s.x, s.y, s.z, 2.5) then
                spawn = s
                break
            end
        end

        if not spawn then
            local ped = PlayerPedId()
            local c = GetEntityCoords(ped)
            spawn = vector4(c.x + 4.0, c.y, c.z, GetEntityHeading(ped))
        end

        local hash = loadModel(model)
        if not hash then
            debugPrint("spawnPurchasedVehicle failed model load", model)
            return
        end

        local veh = CreateVehicle(hash, spawn.x, spawn.y, spawn.z, spawn.w or 0.0, true, false)
        SetVehicleOnGroundProperly(veh)
        SetEntityAsMissionEntity(veh, true, true)
        local plate = ("LARRY%03d"):format(math.random(0, 999))
        SetVehicleNumberPlateText(veh, plate)

        local ped = PlayerPedId()
        SetPedIntoVehicle(ped, veh, -1)

        if colorName and Config.Colors[colorName] then
            local rgb = Config.Colors[colorName].rgb
            SetVehicleModKit(veh, 0)
            SetVehicleCustomPrimaryColour(veh, rgb[1], rgb[2], rgb[3])
            SetVehicleCustomSecondaryColour(veh, rgb[1], rgb[2], rgb[3])
        end

        SetModelAsNoLongerNeeded(hash)
    end
)

RegisterNetEvent(
    "apx-legendary:purchaseResult",
    function(success, message)
        if not message or message == "" then
            return
        end
        if success then
            TriggerEvent("chat:addMessage", {args = {"^2[Larry's RV]^7 " .. message}})
        else
            TriggerEvent("chat:addMessage", {args = {"^1[Larry's RV]^7 " .. message}})
        end
    end
)

CreateThread(
    function()
        Wait(500)

        for id, data in pairs(Config.Dealerships) do
            debugPrint("Initializing dealership:", id, data.label or "noLabel")

            if data.npc and data.npc.coords then
                local npcCfg = data.npc
                local hash = loadModel(npcCfg.model or "s_m_m_highsec_01")
                local ped =
                    CreatePed(
                    4,
                    hash,
                    npcCfg.coords.x,
                    npcCfg.coords.y,
                    npcCfg.coords.z - 1.0,
                    npcCfg.coords.w or 0.0,
                    false,
                    true
                )
                SetEntityAsMissionEntity(ped, true, true)
                SetBlockingOfNonTemporaryEvents(ped, true)
                SetEntityInvincible(ped, true)
                FreezeEntityPosition(ped, true)
                spawnedPeds[#spawnedPeds + 1] = ped
            end

            if data.lotVehicles then
                for _, lot in ipairs(data.lotVehicles) do
                    local vehicleCfg
                    for _, v in ipairs(data.stock or {}) do
                        if v.id == lot.stockId then
                            vehicleCfg = v
                            break
                        end
                    end

                    if vehicleCfg then
                        local hash = loadModel(vehicleCfg.model)
                        local c = lot.coords
                        local veh = CreateVehicle(hash, c.x, c.y, c.z, c.w or 0.0, false, false)
                        SetVehicleDoorsLocked(veh, 2)
                        SetVehicleUndriveable(veh, true)
                        SetEntityInvincible(veh, true)
                        FreezeEntityPosition(veh, true)
                        SetVehicleNumberPlateText(veh, "SHOW")
                        SetModelAsNoLongerNeeded(hash)

                        lotVehicles[#lotVehicles + 1] = {
                            dealershipId = id,
                            entity = veh,
                            config = vehicleCfg
                        }

                        debugPrint("Spawned lot vehicle", vehicleCfg.id, "for", id)
                    else
                        debugPrint("lotVehicles: stockId", lot.stockId, "missing in stock for", id)
                    end
                end
            end
        end
    end
)

CreateThread(
    function()
        while true do
            local sleep = 1000
            local ped = PlayerPedId()
            local pCoords = GetEntityCoords(ped)

            for id, data in pairs(Config.Dealerships) do
                if data.npc and data.npc.coords then
                    local c = data.npc.coords
                    local dist = #(pCoords - vector3(c.x, c.y, c.z))
                    if dist < 15.0 then
                        sleep = 0
                        DrawMarker(
                            1,
                            c.x,
                            c.y,
                            c.z - 1.0,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            1.3,
                            1.3,
                            0.4,
                            200,
                            30,
                            30,
                            120,
                            false,
                            false,
                            2,
                            false,
                            nil,
                            nil,
                            false
                        )
                        if dist < (data.shopRadius or 2.5) and not isUiOpen then
                            showHelpText("Press ~INPUT_CONTEXT~ to browse Larry's stock")
                            if IsControlJustPressed(0, 38) then
                                openDealershipUi(id)
                            end
                        end
                    end
                end
            end

            for _, lot in ipairs(lotVehicles) do
                if DoesEntityExist(lot.entity) then
                    local vCoords = GetEntityCoords(lot.entity)
                    local dist = #(pCoords - vCoords)
                    if dist < 15.0 then
                        sleep = 0
                        DrawMarker(
                            0,
                            vCoords.x,
                            vCoords.y,
                            vCoords.z + 1.2,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.0,
                            0.2,
                            0.2,
                            0.2,
                            255,
                            255,
                            255,
                            160,
                            false,
                            false,
                            2,
                            false,
                            nil,
                            nil,
                            false
                        )
                        if dist < 2.5 then
                            local label =
                                string.format("~y~%s~s~  ~g~$%s", lot.config.name, formatMoney(lot.config.price))
                            drawFloatingText(vCoords + vector3(0.0, 0.0, 1.5), label)
                            showHelpText("Press ~INPUT_CONTEXT~ to purchase this vehicle")
                            if IsControlJustPressed(0, 38) then
                                TriggerServerEvent("apx-legendary:buyFromLot", lot.dealershipId, lot.config.id)
                            end
                        end
                    end
                end
            end

            Wait(sleep)
        end
    end
)
