mqtt_connection = {}

mqtt_connection.clientid = wifi.sta.getmac()
mqtt_connection.server = "central"
mqtt_connection.user = "radon"
mqtt_connection.passwd = "sdfe332fX"
mqtt_connection.cmd_ch = "system/radon/" .. wifi.sta.getmac() .. ""

if (mqtt_connection.m ~= nil) then
    mqtt_connection.m:close()
end

mqtt_connection.connected = false


mqtt_connection.m = mqtt.Client(mqtt_connection.clientid, 30,mqtt_connection.user,mqtt_connection.passwd)

function handle_disconnect(con)
    print ("MQTT disconnected")
    mqtt_connection.connected = false
    MQTTConnect()
end

mqtt_connection.m:on("offline", handle_disconnect)



-- on receive message
mqtt_connection.m:on("message", function(conn, topic, data)
  print(topic .. ":" )
  if data ~= nil then
    print(data)
  end
end)
 

mqtt_connection.m:lwt(mqtt_connection.cmd_ch, "MCU offline", 0, 1)
 
 
function MQTTConnect()
   
    --m:close()

    if mqtt_connection.connected == true then
        return
    end 
    
    mqtt_connection.m:connect(mqtt_connection.server, 1883, 0, function(conn)
      print("MQTT connected")
      mqtt_connection.connected = true
      -- subscribe topic with qos = 0
      mqtt_connection.m:subscribe(mqtt_connection.cmd_ch .. "/cmd",0, function(conn)
        -- publish a message with data = my_message, QoS = 0, retain = 0
        mqtt_connection.m:publish(mqtt_connection.cmd_ch,"MCU online",0,1, function(conn)
          --print("sent")
        end)
      end)
     end)
 end

wifi.sta.eventMonReg(wifi.STA_GOTIP, function() 
    print("STATION_GOT_IP") 
    MQTTConnect()
end)
 


print("Connecting to MQTT")

MQTTConnect()
