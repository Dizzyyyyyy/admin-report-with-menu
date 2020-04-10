if not LoadResourceFile(GetCurrentResourceName(), "PlayerNames.json") then
    SaveResourceFile(GetCurrentResourceName(), "PlayerNames.json", "[]", -1)
end
if not LoadResourceFile(GetCurrentResourceName(), "Reports.json") then
    SaveResourceFile(GetCurrentResourceName(), "Reports.json", "[]", -1)
end

local function OnPlayerConnecting(name, setKickReason, deferrals)

    deferrals.defer()
    deferrals.update("Connecting...")

    local identifiers = GetPlayerIdentifiers(source)
    local steamIdentifier = nil

    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local id = GetPlayerIdentifier(source, i)

        if string.find(id, "steam") then
            steamIdentifier = id
        end

    end

    if not steamIdentifier then
        --deferrals.done("You are not connected to steam.")
        deferrals.done()
    else
        deferrals.done()
    end
    
    --deferrals.done("Debug Kick.")
    

    --local data = json.encode(identifiers)

    --local PlayerData = json.decode(LoadResourceFile(GetCurrentResourceName(), "PlayerNames.json"))
    --table.insert(PlayerData, identifiers)
   -- SaveResourceFile(GetCurrentResourceName(), "PlayerNames.json", json.encode(PlayerNames), -1)

end

AddEventHandler("playerConnecting", OnPlayerConnecting)


RegisterServerEvent("Report:NewReport")
AddEventHandler("Report:NewReport", function(id, reason)
    TriggerClientEvent("Report:ShowReportNotification", id, reason)
    TriggerClientEvent('chat:addMessage', -1, {
        template = ('<link rel="stylesheet" href="https://use.fontawesome.com/releases/v5.11.1/css/all.css" integrity="sha384-IT8OQ5/IfeLGe8ZMxjj3QQNqT0zhBJSiFCL3uolrGgKRuenIU+mMS94kck/AHZWu" crossorigin="anonymous"><div style="padding: 0.3vw; margin: 0.5vw; background-color: rgba(100, 100, 100, 0.4); border-radius: 3px;"><i class="fas fa-address-card"></i> <b>{0}</b>{1}<br>{2}</div>'),
        args = {"New Player Report on ", "(" .. id .. ") " .. GetPlayerName(id), '"' .. reason .. '"'}
    });

    steamId = "Unkown"
    PsteamId = "Unkown"

    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local _id = GetPlayerIdentifier(source, i)

        if string.find(_id, "steam") then
            steamId = _id
        end

    end

    for i = 0, GetNumPlayerIdentifiers(id) - 1 do
        local _id = GetPlayerIdentifier(id, i)

        if string.find(_id, "steam") then
            PsteamId = _id
        end

    end

    report = {SenderName = GetPlayerName(source), SenderSteam = steamId, PlayerId = id, PlayerName = GetPlayerName(id), PlayerSteam = PsteamId, reason = reason}
    local reports = json.decode(LoadResourceFile(GetCurrentResourceName(), "Reports.json"))
    table.insert(reports, report)
    SaveResourceFile(GetCurrentResourceName(), "Reports.json", json.encode(reports), -1)
end)

function GetPlayerPermission(player, perm) 
    return true
end
