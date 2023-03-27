ESX = nil
local MySQL = require('mysql-async') -- Make sure to include the appropriate MySQL library for your server

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

AddEventHandler('esx:playerLoaded', function(playerId, xPlayer)
    MySQL.Async.fetchScalar('SELECT first_join FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    }, function(first_join)
        local isFirstTime = first_join == 1

        if isFirstTime then
            -- Show the tutorial
            TriggerClientEvent('presentation_tutorial:showTutorial', playerId)

            -- Update the `first_join` value in the database
            MySQL.Async.execute('UPDATE users SET first_join = 0 WHERE identifier = @identifier', {
                ['@identifier'] = xPlayer.identifier
            })
        end
    end)
end)

