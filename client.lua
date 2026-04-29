local runtimeTexture = "customPlates"
local vehShare = "vehshare"
local plateTxd = CreateRuntimeTxd(runtimeTexture)

CreateRuntimeTextureFromImage(plateTxd, "yankton_plate", "black.png")
AddReplaceTexture(vehShare, "yankton_plate", runtimeTexture, "yankton_plate")
AddReplaceTexture(vehShare, "yankton_plate_n", runtimeTexture, "yankton_plate")

local flipinstalled = false
local cooldown = 0

-- =============================
-- HELPERS
-- =============================
local function applyHidden(vehicle)
    SetVehicleNumberPlateTextIndex(vehicle, 5)
end

local function applyVisible(vehicle, index)
    SetVehicleNumberPlateTextIndex(vehicle, index or 0)
end

local function getSafeIndex(vehicle)
    local state = Entity(vehicle).state
    if state and state.fp_index then
        return state.fp_index
    end

    local idx = GetVehicleNumberPlateTextIndex(vehicle)
    if idx == nil then return 0 end
    return idx
end

-- =============================
-- CACHE
-- =============================
lib.onCache('vehicle', function(vehicle)
    if not vehicle then
        flipinstalled = false
        return
    end

    if GetPedInVehicleSeat(vehicle, -1) == PlayerPedId() then
        flipinstalled = lib.callback.await(
            'bar-fakeplate:IsFlippedInstalled',
            500,
            GetVehicleNumberPlateText(vehicle)
        )
    end
end)

-- =============================
-- COMMAND
-- =============================
RegisterCommand('plateflip', function()
    if not flipinstalled then return end

    if (GetGameTimer() - cooldown) < Config.SwitchCooldown * 1000 then
        return lib.notify({ type = 'error', description = "Cooldown active..." })
    end

    local ped = PlayerPedId()
    if not IsPedInAnyVehicle(ped, false) then return end

    local vehicle = GetVehiclePedIsIn(ped, false)
    if GetPedInVehicleSeat(vehicle, -1) ~= ped then return end

    local netId = NetworkGetNetworkIdFromEntity(vehicle)
    local state = Entity(vehicle).state or {}

    if not state.fp_hidden then
        -- HIDE
        TriggerServerEvent('bar-fakeplate:TogglePlate', netId, true)
        applyHidden(vehicle)
    else
        -- SHOW
        TriggerServerEvent('bar-fakeplate:TogglePlate', netId, false)

        local index = getSafeIndex(vehicle)
        applyVisible(vehicle, index)
    end

    cooldown = GetGameTimer()
end, false)

RegisterKeyMapping('plateflip', 'Flip plate', 'keyboard', Config.FlipKey)

-- =============================
-- FULL SYNC HANDLER
-- =============================
AddStateBagChangeHandler('fp_hidden', nil, function(bagName)
    local entity = GetEntityFromStateBagName(bagName)
    if not entity or not DoesEntityExist(entity) then return end

    local state = Entity(entity).state or {}

    if state.fp_hidden then
        applyHidden(entity)
    else
        applyVisible(entity, state.fp_index or 0)
    end
end)

-- =============================
-- INSTALL SYSTEM
-- =============================
RegisterNetEvent('bar-fakeplate:InstallPlateFlipper', function()
    local vehicle, distance = GetClosestVehicle()
    if not vehicle or distance > 5 then
        return lib.notify({ type = 'error', description = "No vehicle nearby!" })
    end

    local plate = GetVehicleNumberPlateText(vehicle)

    local owned = lib.callback.await(
        'bar-fakeplate:callback:IsVehicleOwned',
        false,
        plate
    )

    if not owned then
        return lib.notify({ type = 'error', description = "Not your vehicle!" })
    end

    local netId = NetworkGetNetworkIdFromEntity(vehicle)

    if lib.progressBar({
        duration = Config.InstallDuration,
        label = 'Installing...',
        canCancel = true,
        anim = { dict = 'mini@repair', clip = 'fixing_a_player' },
        disable = { move = true, combat = true }
    }) then

        TriggerServerEvent('bar-fakeplate:InstallPlateFlipper', plate, GetVehicleNumberPlateTextIndex(vehicle))

        -- INIT SAFE STATE (IMPORTANT)
        TriggerServerEvent('bar-fakeplate:InitPlateData', netId, {
            index = GetVehicleNumberPlateTextIndex(vehicle) or 0,
            plate = plate
        })
    else
        lib.notify({ type = 'error', description = "Installation cancelled!" })
    end
end)

-- =============================
-- NOTIFY
-- =============================
RegisterNetEvent('bar-fakeplate:notify', function(data)
    lib.notify(data)
end)