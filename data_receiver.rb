#!/usr/bin/env ruby
require 'socket'
require 'bindata'

# X-Plane struct are 4-bytes data.
# First are the index of data.
# Next height data are floats.
class XStruct < BinData::Record
  endian :little

  struct :pitch_roll_headings do
    uint32 :x_index

    float :pitch
    float :roll
    float :heading_true
    float :heading_mag
    skip length: 4 * 4
  end

  struct :lat_long_alt do
    uint32 :x_index

    float :latitude
    float :longitude
    float :altitude
    skip length: 4 * 5
  end
end

# TODO: parse blocks to get x_indices
# 58:41:54:54:32:2c:34:30:2e:36:2c:30:2e:37:2c:2d:30:2e:30:2c:2d:30:2e:30:30:30:34:2c:30:2e:30:30:30:31:2c:30:2e:30:30:30:31:2c:2d:30:2e:30:2c:2d:30:2e:30:2c:2d:30:2e:30:2c:30:2e:30:30:2c:31:2e:30:30:2c:2d:30:2e:30:31

xattr2_sample = '58:41:54:54:32:2c:34:30:2e:36:2c:30:2e:37:2c:2d:30:2e:30:2c:2d:30:2e:30:30:30:34:2c:30:2e:30:30:30:31:2c:30:2e:30:30:30:31:2c:2d:30:2e:30:2c:2d:30:2e:30:2c:2d:30:2e:30:2c:30:2e:30:30:2c:31:2e:30:30:2c:2d:30:2e:30:31'
xattr2 = xattr2_sample.gsub(':', '').unpack('H*')

socket = UDPSocket.new
socket.bind('127.0.0.1', 49_003)

while 1
  bytes = socket.recvfrom(65_536)
  mesg = bytes[0]
  type = mesg.slice(0..4)
  content = mesg.slice(5..mesg.length - 4)
  # puts type
  # p content
  data = XStruct.read(content)
  p data[:pitch_roll_headings]
  p data[:lat_long_alt]
end
