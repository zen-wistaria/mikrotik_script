# name   : Zoom Priority
# file   : zoom_priority.rsc
# run on : RouterOS v7
# date   : 05-03-2025
# by     : zen-wistaria

# Remove Existing Firewall Address-list for Zoom
/ip firewall address-list
:foreach i in=[find where list="Zoom"] do={remove $i}

# Create Firewall Address-list
/ip firewall address-list
add address=3.7.35.0/25 list=Zoom
add address=3.21.137.128/25 list=Zoom
add address=3.25.41.128/25 list=Zoom
add address=3.80.20.128/25 list=Zoom
add address=3.104.34.128/25 list=Zoom
add address=3.120.121.0/25 list=Zoom
add address=3.127.194.128/25 list=Zoom
add address=3.208.72.0/25 list=Zoom
add address=3.235.71.128/25 list=Zoom
add address=3.235.72.128/25 list=Zoom
add address=3.235.73.0/25 list=Zoom
add address=3.235.82.0/23 list=Zoom
add address=3.235.96.0/23 list=Zoom
add address=4.34.125.128/25 list=Zoom
add address=4.35.64.128/25 list=Zoom
add address=8.5.128.0/23 list=Zoom
add address=13.52.6.128/25 list=Zoom
add address=15.220.80.0/24 list=Zoom
add address=15.220.81.0/25 list=Zoom
add address=18.254.23.128/25 list=Zoom
add address=18.254.61.0/25 list=Zoom
add address=20.203.158.80/28 list=Zoom
add address=20.203.190.192/26 list=Zoom
add address=50.239.202.0/23 list=Zoom
add address=50.239.204.0/24 list=Zoom
add address=52.61.100.128/25 list=Zoom
add address=52.202.62.192/26 list=Zoom
add address=64.125.62.0/24 list=Zoom
add address=64.211.144.0/24 list=Zoom
add address=64.224.32.0/19 list=Zoom
add address=65.39.152.0/24 list=Zoom
add address=69.174.57.0/24 list=Zoom
add address=69.174.108.0/22 list=Zoom
add address=99.79.20.0/25 list=Zoom
add address=101.36.167.0/24 list=Zoom
add address=101.36.170.0/23 list=Zoom
add address=103.122.166.0/23 list=Zoom
add address=111.33.115.0/25 list=Zoom
add address=111.33.181.0/25 list=Zoom
add address=115.110.154.192/26 list=Zoom
add address=115.114.56.192/26 list=Zoom
add address=115.114.115.0/26 list=Zoom
add address=115.114.131.0/26 list=Zoom
add address=120.29.148.0/24 list=Zoom
add address=121.244.146.0/27 list=Zoom
add address=134.224.0.0/16 list=Zoom
add address=144.195.0.0/16 list=Zoom
add address=147.124.96.0/19 list=Zoom
add address=149.137.0.0/17 list=Zoom
add address=156.45.0.0/17 list=Zoom
add address=159.124.0.0/16 list=Zoom
add address=160.1.56.128/25 list=Zoom
add address=161.199.136.0/22 list=Zoom
add address=162.12.232.0/22 list=Zoom
add address=162.255.36.0/22 list=Zoom
add address=165.254.88.0/23 list=Zoom
add address=166.108.64.0/18 list=Zoom
add address=170.114.0.0/16 list=Zoom
add address=173.231.80.0/20 list=Zoom
add address=192.204.12.0/22 list=Zoom
add address=198.251.128.0/17 list=Zoom
add address=202.177.207.128/27 list=Zoom
add address=203.200.219.128/27 list=Zoom
add address=204.80.104.0/21 list=Zoom
add address=204.141.28.0/22 list=Zoom
add address=206.247.0.0/16 list=Zoom
add address=207.226.132.0/24 list=Zoom
add address=209.9.211.0/24 list=Zoom
add address=209.9.215.0/24 list=Zoom
add address=213.19.144.0/24 list=Zoom
add address=213.19.153.0/24 list=Zoom
add address=213.244.140.0/24 list=Zoom
add address=221.122.63.0/24 list=Zoom
add address=221.122.64.0/24 list=Zoom
add address=221.122.88.64/27 list=Zoom
add address=221.122.88.128/25 list=Zoom
add address=221.122.89.128/25 list=Zoom
add address=221.123.139.192/27 list=Zoom

# Remove Existing Firewall Mangle for Zoom
/ip firewall mangle
:foreach i in=[find where comment="==================== Zoom"] do={remove $i}

# Create Firewall Mangle
/ip firewall mangle
add action=mark-connection chain=prerouting dst-address-list=Zoom dst-port=443,8801,8802 new-connection-mark=Zoom passthrough=yes protocol=tcp comment="==================== Zoom"
add action=mark-connection chain=prerouting dst-address-list=Zoom dst-port=3478,3479,8801-8810 new-connection-mark=Zoom passthrough=yes protocol=udp comment="==================== Zoom"
add action=mark-packet chain=forward connection-mark=Zoom new-packet-mark=Zoom passthrough=no comment="==================== Zoom"

# Create Queue Type (Skip if exists)
/queue type
:if ([find where name="FQ-Codel"] = "") do={
    add fq-codel-interval=10ms fq-codel-limit=1000 kind=fq-codel name=FQ-Codel
}

# Create Queue Tree (Skip if exists)
/queue tree
:if ([find where name="Zoom"] = "") do={
    add limit-at=100M max-limit=300M name="Zoom" packet-mark=Zoom parent=global priority=7 queue=FQ-Codel
}
