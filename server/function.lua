
--███████╗██████╗  █████╗ ███╗   ███╗███████╗██╗    ██╗ ██████╗ ██████╗ ██╗  ██╗
--██╔════╝██╔══██╗██╔══██╗████╗ ████║██╔════╝██║    ██║██╔═══██╗██╔══██╗██║ ██╔╝
--█████╗  ██████╔╝███████║██╔████╔██║█████╗  ██║ █╗ ██║██║   ██║██████╔╝█████╔╝ 
--██╔══╝  ██╔══██╗██╔══██║██║╚██╔╝██║██╔══╝  ██║███╗██║██║   ██║██╔══██╗██╔═██╗ 
--██║     ██║  ██║██║  ██║██║ ╚═╝ ██║███████╗╚███╔███╔╝╚██████╔╝██║  ██║██║  ██╗
--╚═╝     ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝     ╚═╝╚══════╝ ╚══╝╚══╝  ╚═════╝ ╚═╝  ╚═╝╚═╝  ╚═╝

ESX, QBCore = nil, nil

if Config.Framework == 'esx' then
    while ESX == nil do
        TriggerEvent(Config.FrameworkTriggers.main, function(obj) ESX = obj end)
    end

elseif Config.Framework == 'qbus' then
    while QBCore == nil do
        TriggerEvent(Config.FrameworkTriggers.main, function(obj) QBCore = obj end)
    end

elseif Config.Framework == 'other' then
    --Add your own framework code here. 

end

--███╗   ███╗███████╗██╗     ██████╗ ██╗███╗  ██╗ ██████╗ ███████╗███╗  ██╗
--████╗ ████║██╔════╝██║     ██╔══██╗██║████╗ ██║██╔════╝ ██╔════╝████╗ ██║
--██╔████╔██║█████╗  ██║     ██║  ██║██║██╔██╗██║██║  ██╗ █████╗  ██╔██╗██║
--██║╚██╔╝██║██╔══╝  ██║     ██║  ██║██║██║╚████║██║  ╚██╗██╔══╝  ██║╚████║
--██║ ╚═╝ ██║███████╗███████╗██████╔╝██║██║ ╚███║╚██████╔╝███████╗██║ ╚███║
--╚═╝     ╚═╝╚══════╝╚══════╝╚═════╝ ╚═╝╚═╝  ╚══╝ ╚═════╝ ╚══════╝╚═╝  ╚══╝


function Notification(notif_type, message, source)
    if notif_type and message then
        if Config.NotificationType.client == 'esx' then
			local xPlayer = ESX.GetPlayerFromId(source)
            xPlayer.showNotification(message)
        
        elseif Config.NotificationType.client == 'qbcore' then
            if notif_type == 1 then
                TriggerClientEvent('QBCore:Notify', message, 'success')
            elseif notif_type == 2 then
                TriggerClientEvent('QBCore:Notify', message, 'primary')
            elseif notif_type == 3 then
                TriggerClientEvent('QBCore:Notify', message, 'error')
            end

        elseif Config.NotificationType.client == 'mythic_old' then
            if notif_type == 1 then
                TriggerClientEvent('mythic_notify:client:DoCustomHudText', source, { type = 'success', text = message})
            elseif notif_type == 2 then
                TriggerClientEvent('mythic_notify:client:DoCustomHudText', source, { type = 'inform', text = message})
            elseif notif_type == 3 then
                TriggerClientEvent('mythic_notify:client:DoCustomHudText', source, { type = 'error', text = message})
            end
        elseif Config.NotificationType.client == 'mythic_new' then
            if notif_type == 1 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'success', text = message})
            elseif notif_type == 2 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'inform', text = message})
            elseif notif_type == 3 then
                TriggerClientEvent('mythic_notify:client:SendAlert', source, { type = 'error', text = message})
            end

        elseif Config.NotificationType.client == 'chat' then
            TriggerClientEventEvent('chatMessage', message)
            
        elseif Config.NotificationType.client == 'other' then
            --add your own notification.
            
        end
    end
end