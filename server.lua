local vehicles = {}
local vehicles_plate = {}

-- =============================
-- GET: Is Flipper Installed
-- =============================
lib.callback.register('bar-fakeplate:IsFlippedInstalled', function(source, plate)
    if not plate then return false end

    if vehicles[plate] ~= nil then
        return vehicles[plate]
    end

    local installed = MySQL.scalar.await(
        'SELECT flipper_installed FROM player_vehicles WHERE plate = ?',
        { plate }
    )

    installed = installed == 1 or installed == true
    vehicles[plate] = installed

    return installed
end)

-- =============================
-- OWNERSHIP
-- =============================
lib.callback.register('bar-fakeplate:callback:IsVehicleOwned', function(source, plate)
    if not plate then return false end
    return IsVehicleOwned(plate)
end)

-- =============================
-- JOB CHECK
-- =============================
function HasWhitelistedJob(playerId)
    if not Config.UseJobCheck then return true end

    local jobName = GetPlayerJob(playerId)
    if not jobName then return false end

    for _, job in pairs(Config.JobsAllowed) do
        if job == jobName then
            return true
        end
    end

    return false
end

-- =============================
-- INIT (SAFE FIX)
-- =============================
RegisterNetEvent('bar-fakeplate:InitPlateData', function(netId, data)
    local entity = NetworkGetEntityFromNetworkId(netId)
    if not entity or entity == 0 then return end

    local state = Entity(entity).state

    -- 🔥 only set if not exists (NO overwrite spam)
    if state.fp_index == nil then
        state.fp_index = data.index or 0
    end

    if state.fp_plate == nil then
        state.fp_plate = data.plate
    end

    state.fp_hidden = false
end)

-- =============================
-- INSTALL FLIPPER
-- =============================
RegisterNetEvent('bar-fakeplate:InstallPlateFlipper', function(plate, plateIndex)
    local src = source
    if not plate then return end

    if not HasWhitelistedJob(src) then return end

    local removed = exports.ox_inventory:RemoveItem(src, 'fakeplate', 1)
    if not removed then return end

    MySQL.update(
        "UPDATE player_vehicles SET flipper_installed = 1 WHERE plate = ?",
        { plate }
    )

    vehicles[plate] = true
    vehicles_plate[plate] = plateIndex or 0

    TriggerClientEvent('bar-fakeplate:notify', src, {
        description = "Plate flipper installed successfully!",
        type = 'success'
    })
end)

RegisterNetEvent('bar-fakeplate:TogglePlate', function(netId, state)
    local entity = NetworkGetEntityFromNetworkId(netId)
    if not entity or entity == 0 then return end

    local entState = Entity(entity).state

    -- 🔥 NEVER touch index here again (IMPORTANT)
    -- keys systems react to index changes

    if state then
        entState.fp_hidden = true
    else
        entState.fp_hidden = false
    end
end)

-- =============================
-- LOCK VEHICLE
-- =============================
RegisterNetEvent('bar-fakeplate:SetVehicleDoorsLocked', function(netId, state)
    local src = source
    if not HasWhitelistedJob(src) then return end

    local entity = NetworkGetEntityFromNetworkId(netId)
    if not entity or entity == 0 then return end

    SetVehicleDoorsLocked(entity, state)
    FreezeEntityPosition(entity, state == 2)
end)

-- =============================
-- USE ITEM
-- =============================
RegisterUseableItem('fakeplate', function(source)
     if not HasWhitelistedJob(source) then
    if HasWhitelistedJob(source) then
        TriggerClientEvent('bar-fakeplate:InstallPlateFlipper', source)
    else
        TriggerClientEvent('bar-fakeplate:notify', source, {
            type = 'error',
            description = "You are not allowed to install this!"
        })
    end
end)