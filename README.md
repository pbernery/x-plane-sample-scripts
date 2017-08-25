# X-Plane broadcasted AHRS data

This repository contains scripts to explore [X-Plane](http://www.x-plane.com) [AHRS](https://en.wikipedia.org/wiki/Attitude_and_heading_reference_system) data
broadcasted on the network when "Broadcast to all copies of Foreflight,
WingX Pro, Aerovie, and SkyDemon on the network" is enabled.

`data_receiver.rb` tries to parse data when some data in the "Data output" is set to be output.

`broadcast_receiver.rb` displays data received when "Broadcast to ForeFlight..." is enabled.

A `Vagrantfile` is also provided to make listening to the X-Plane broadcast possible when using the same physical machine.

