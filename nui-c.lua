local display = false

RegisterCommand("report", function(source, args)
    SetDisplay(true);
    pid = table.remove(args, 1);
    reason = "";
    for i,line in ipairs(args) do
        reason = reason .. line .. " ";
    end
    SendNUIMessage({
        type = "Show",
        data = json.encode({pid = pid, reason = reason})
    })
end)

RegisterNUICallback("exit", function(data)
    SetDisplay(false)
end)

RegisterNUICallback("success", function(data)
    SetDisplay(false);
    ShowNotification("Your Report on ~o~"..data.name.."~w~ has been send to our Admins.\nIt has also been stored in our system.")
    TriggerServerEvent("Report:NewReport", data.id, data.reason)
end)

RegisterNUICallback("error", function(data)
    TriggerEvent("Report:ShowNotification", data.error)
    SetDisplay(false)
end)

function SetDisplay(bool)
    display = bool
    SetNuiFocus(bool, bool)
    SendNUIMessage({
        type = "ui",
        status = bool
    })
end

Citizen.CreateThread(function()

    TriggerEvent('chat:addSuggestion', '/report', '', {
        { name="Id", help="Player Id" },
        { name="Reason", help="Report Reason" }
    })

    while true do
        Citizen.Wait(0)
        if display then
            DisableControlAction(0, 1, display) -- LookLeftRight
            DisableControlAction(0, 2, display) -- LookUpDown
            DisableControlAction(0, 142, display) -- MeleeAttackAlternate
            DisableControlAction(0, 18, display) -- Enter
            DisableControlAction(0, 322, display) -- ESC
            DisableControlAction(0, 106, display) -- VehicleMouseControlOverride
        end
        --if IsControlJustReleased(1, 212) then --Home button to open form
        --    SetDisplay(not display)
        --end
    end
end)

Citizen.CreateThread(function() --Update Resource Menu Info
    while true do
        Citizen.Wait(1000) 
        GetPlayerData()
        Citizen.Wait(20000) 
    end
end)

function GetPlayerData()
    local ptable = {}
    local players = {}
    for i = 0, 255 do
        if NetworkIsPlayerActive(i) then
            table.insert(ptable, i)
        end
    end
    for _, i in ipairs(ptable) do
        local pdata = {}
        pdata["id"] = GetPlayerServerId(i)
        pdata["name"] = GetPlayerName(i)
        table.insert(players, pdata)
    end
    SendNUIMessage({
        type = "Players",
        data = json.encode(players)
    })
end


function sanitize(txt)
    local replacements = {
        ['&' ] = '&amp;', 
        ['<' ] = '&lt;', 
        ['>' ] = '&gt;', 
        ['\n'] = '<br/>'
    }
    return txt
        :gsub('[&<>\n]', replacements)
        :gsub(' +', function(s) return ' '..('&nbsp;'):rep(#s-1) end)
end

RegisterNetEvent('Report:ShowReportNotification')
AddEventHandler('Report:ShowReportNotification',function(inputText)
    SetNotificationTextEntry("STRING");
    AddTextComponentString('Reason: "'..inputText..'"');
    SetNotificationFlashColor(255, 0, 0, 1);
    SetNotificationBackgroundColor(6);
    SetNotificationMessage("CHAR_BLOCKED", "CHAR_BLOCKED", true, 0, "System", "You have been ~h~reported~s~");
    DrawNotification(false, true);
end)

function ShowNotification(text)
    SetNotificationTextEntry("STRING")
    AddTextComponentString(text)
    DrawNotification(false, true)
end