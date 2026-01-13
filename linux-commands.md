###Connecting to WiFi
#WiFi list
    nmcli device wifi
#Connect to WiFi
    nmcli --ask device wifi connect "[Nazwa]"
#Disconnect
    nmcli connection delete "[Wifi-Name]"
#missing property?
    delete network and connect again

###Connecting to Bluetooth
#Init bluetooth
    bluetoothctl power on
    bluetoothctl discoverable on
    bluetoothctl pairable on
#Connect to device
    bluetoothctl scan on
    bluetoothctl devices
    bluetoothctl pair [mac-address]
    bluetoothctl connect [mac-address]
#Disconnecting
    bluetoothctl disconnect

###USB drive
#Show available disks
    lsblk
#Mount disk
    sudo mount [disk] /mnt/usb
#Use it as normal directory
    .
#Unmount
    sudo umount /mnt/usb

###Brightness
#Set brightness
    brightnessctl set n%, n - brightness percentage value

###Audio
#Raise/lower output volume
    swayosd-client --output-volume [+-n], n - percentage value --max-volume [+m], m - max volume
#Raise/lower input volume
    swayosd-client --input-volume [+-n] --device [device|@DEFAULT_SOURCE@]

#Toggle mute
    swayosd-client --output-volume mute-toggle
    swayosd-client --input-volume mute-toggle
#Change to bluetooth device
    swayosd-client --device [device]
#List devices
    pactl list short [sinks|sources]
