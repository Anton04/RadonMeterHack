function startprogram()
    dofile('synctime.lua')
    dofile('tcp-ota.lua')
    dofile('MQTT.lua')
end

if (wifi.sta.getip() ~= nil) then
    startprogram()
else
    wifi.sta.eventMonReg(wifi.STA_GOTIP, startprogram)
end