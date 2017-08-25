#!/usr/bin/env ruby
# coding: utf-8
require 'socket'

socket = UDPSocket.new
socket.bind('0.0.0.0', 49_002)

# Extract the content of an X-Plane plain text message
# Removes the message type, the message index and the following coma.
def content_from(mesg)
  mesg.slice(6..mesg.length).split(',')
end

loop do
  mesg, addr = socket.recvfrom(512)
  puts "#{Time.now.to_s} - Receiving from #{addr}"

  mesg_type = mesg[0..3]
  case mesg_type
  when 'XATT'
    items = content_from(mesg)
    # RTS = relative to speed
    # RTH = relative to heading
    # RTM = relative to movement
    puts "#{mesg_type}: Bearing (mag): #{items[0]} - Pitch: #{items[1]} - Roll: #{items[2]} - Acc X: #{items[3]} - Acc Y: #{items[4]} - Acc Z: #{items[5]} - RTM: #{items[6]} - RTM (pitch): #{items[7]} - RTM: #{items[8]} - ???: #{items[9]} - ???: #{items[10]} - ???: #{items[11]}"
  when 'XGPS'
    items = content_from(mesg)
    puts "#{mesg_type}: Long: #{items[0]} - Lat: #{items[1]} - Alt AMSL in m: #{items[2]} - Bearing: #{items[3]} - TAS / 2?: #{items[4]}"
  when 'XTRA'
    items = content_from(mesg)
    puts "XTRA message received. Not decoded yet"
    p items
  else
    puts "Unknown message type: #{mesg_type}"
  end
end

socket.close

# Sample messages
#
# on port 49707, broadcasted to 239.255.1.1:
# 42:45:43:4e:00:01:01:01:00:00:00:7a:ae:01:00:01:00:00:00:68:bf:4d:61:63:42:6f:6f:6b:20:50:72:6f:20:64:65:20:50:68:69:6c:69:70:70:65:00
# => BECN ... MacBook Pro de Philippe\0
# ==> Semble broadcasté le nom de la machine pour ensuite pouvoir s'y connecter

# To: 192.168.0.35 (specific IP), port 49002
# 58:47:50:53:31:2c:37:2e:36:34:30:33:34:33:2c:34:38:2e:35:34:35:33:38:38:2c:31:34:36:2e:33:37:30:38:2c:32:32:38:2e:38:30:38:39:2c:30:2e:30:30:30:32
# => XGPS1, longitude, latitude, altitude?, cap?, vitesse?

# To: 192.168.0.35 (specific IP), port 49002
# 58:41:54:54:31:2c:32:32:38:2e:33:2c:30:2e:37:2c:30:2e:31:2c:30:2e:30:30:30:30:2c:30:2e:30:30:30:30:2c:30:2e:30:30:30:30:2c:2d:30:2e:30:2c:30:2e:30:2c:30:2e:30:2c:2d:30:2e:30:30:2c:31:2e:30:30:2c:2d:30:2e:30:31
# => XATT1
# => Problablement les mêmes infos que XATT2 avec une légère différence

# 58:54:52:41:31:2c:31:2c:34:39:2e:32:30:33:36:31:32:2c:37:2e:30:33:33:33:30:34:2c:33:34:34:39:38:2c:30:2c:31:2c:34:34:2c:33:35:33:2c:31:35:33:37:38:33
# => XTRA1
# => Autres informations

# It seems that message types are suffixed with "1" when pushed to one
# ip, with "2" when broadcasted.
