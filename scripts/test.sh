#!/bin/bash

if [[ $(id -u) -ne 0 ]] ; then
    echo "Please run with sudo"
    exit 1
fi

run () {
    echo "$@"
    "$@" || exit 1
}

create_router1 () { # fc00:a::/64
    # setup namespaces
    run ip netns add host1
    run ip netns add router1

    # setup veth peer
    run ip link add veth-h1-rt1 type veth peer name veth-rt1-h1
    run ip link set veth-h1-rt1 netns host1
    run ip link set veth-rt1-h1 netns router1

    # host1 configuration
    run ip netns exec host1 ip link set lo up
    run ip netns exec host1 ip link set veth-h1-rt1 up
    run ip netns exec host1 ip addr add fc00:a::2/64 dev veth-h1-rt1
    run ip netns exec host1 ip -6 route add fc00:b::/64 via fc00:a::1
    run ip netns exec host1 ip -6 route add fc00:c::/64 via fc00:a::1
    run ip netns exec host1 ip -6 route add fc00:d::/64 via fc00:a::1
    run ip netns exec host1 ip -6 route add fc00:e::/64 via fc00:a::1
    run ip netns exec host1 ip -6 route add fc00:12::/64 via fc00:a::1
    run ip netns exec host1 ip -6 route add fc00:25::/64 via fc00:a::1
    run ip netns exec host1 ip -6 route add fc00:13::/64 via fc00:a::1
    run ip netns exec host1 ip -6 route add fc00:34::/64 via fc00:a::1
    run ip netns exec host1 ip -6 route add fc00:45::/64 via fc00:a::1

    # router1 configuration
    run ip netns exec router1 ip link set lo up
    run ip netns exec router1 ip link set veth-rt1-h1 up
    run ip netns exec router1 ip addr add fc00:a::1/64 dev veth-rt1-h1

    # sysctl for router1
    ip netns exec router1 sysctl net.ipv6.conf.all.forwarding=1
    ip netns exec router1 sysctl net.ipv6.conf.all.seg6_enabled=1
}

create_router2 () {
    # setup namespaces
    run ip netns add host2
    run ip netns add router2

    # setup veth peer
    run ip link add veth-h2-rt2 type veth peer name veth-rt2-h2
    run ip link set veth-h2-rt2 netns host2
    run ip link set veth-rt2-h2 netns router2

    # host2 configuration
    run ip netns exec host2 ip link set lo up
    run ip netns exec host2 ip link set veth-h2-rt2 up
    run ip netns exec host2 ip addr add fc00:b::2/64 dev veth-h2-rt2
    run ip netns exec host2 ip -6 route add fc00:a::/64 via fc00:b::1
    run ip netns exec host2 ip -6 route add fc00:c::/64 via fc00:b::1
    run ip netns exec host2 ip -6 route add fc00:d::/64 via fc00:b::1
    run ip netns exec host2 ip -6 route add fc00:e::/64 via fc00:b::1
    run ip netns exec host2 ip -6 route add fc00:12::/64 via fc00:b::1
    run ip netns exec host2 ip -6 route add fc00:25::/64 via fc00:b::1
    run ip netns exec host2 ip -6 route add fc00:13::/64 via fc00:b::1
    run ip netns exec host2 ip -6 route add fc00:34::/64 via fc00:b::1
    run ip netns exec host2 ip -6 route add fc00:45::/64 via fc00:b::1

    # router2 configuration
    run ip netns exec router2 ip link set lo up
    run ip netns exec router2 ip link set veth-rt2-h2 up
    run ip netns exec router2 ip addr add fc00:b::1/64 dev veth-rt2-h2

    # sysctl for router2
    ip netns exec router2 sysctl net.ipv6.conf.all.forwarding=1
    ip netns exec router2 sysctl net.ipv6.conf.all.seg6_enabled=1
}

create_router3 () {
    # setup namespaces
    run ip netns add host3
    run ip netns add router3

    # setup veth peer
    run ip link add veth-h3-rt3 type veth peer name veth-rt3-h3
    run ip link set veth-h3-rt3 netns host3
    run ip link set veth-rt3-h3 netns router3

    # host3 configuration
    run ip netns exec host3 ip link set lo up
    run ip netns exec host3 ip link set veth-h3-rt3 up
    run ip netns exec host3 ip addr add fc00:c::2/64 dev veth-h3-rt3
    run ip netns exec host3 ip -6 route add fc00:a::/64 via fc00:c::1
    run ip netns exec host3 ip -6 route add fc00:b::/64 via fc00:c::1
    run ip netns exec host3 ip -6 route add fc00:d::/64 via fc00:c::1
    run ip netns exec host3 ip -6 route add fc00:e::/64 via fc00:c::1
    run ip netns exec host3 ip -6 route add fc00:12::/64 via fc00:c::1
    run ip netns exec host3 ip -6 route add fc00:25::/64 via fc00:c::1
    run ip netns exec host3 ip -6 route add fc00:13::/64 via fc00:c::1
    run ip netns exec host3 ip -6 route add fc00:34::/64 via fc00:c::1
    run ip netns exec host3 ip -6 route add fc00:45::/64 via fc00:c::1

    # router3 configuration
    run ip netns exec router3 ip link set lo up
    run ip netns exec router3 ip link set veth-rt3-h3 up
    run ip netns exec router3 ip addr add fc00:c::1/64 dev veth-rt3-h3

    # sysctl for router3
    ip netns exec router3 sysctl net.ipv6.conf.all.forwarding=1
    ip netns exec router3 sysctl net.ipv6.conf.all.seg6_enabled=1

    # seg6_enable for host3
    ip netns exec host3 sysctl net.ipv6.conf.all.forwarding=1
    ip netns exec host3 sysctl net.ipv6.conf.all.seg6_enabled=1
    ip netns exec host3 sysctl net.ipv6.conf.veth-h3-rt3.seg6_enabled=1

}

create_router4 () {
    # setup namespaces
    run ip netns add host4
    run ip netns add router4

    # setup veth peer
    run ip link add veth-h4-rt4 type veth peer name veth-rt4-h4
    run ip link set veth-h4-rt4 netns host4
    run ip link set veth-rt4-h4 netns router4

    # host4 configuration
    run ip netns exec host4 ip link set lo up
    run ip netns exec host4 ip link set veth-h4-rt4 up
    run ip netns exec host4 ip addr add fc00:d::2/64 dev veth-h4-rt4
    run ip netns exec host4 ip -6 route add fc00:a::/64 via fc00:d::1
    run ip netns exec host4 ip -6 route add fc00:b::/64 via fc00:d::1
    run ip netns exec host4 ip -6 route add fc00:c::/64 via fc00:d::1
    run ip netns exec host4 ip -6 route add fc00:e::/64 via fc00:d::1
    run ip netns exec host4 ip -6 route add fc00:12::/64 via fc00:d::1
    run ip netns exec host4 ip -6 route add fc00:25::/64 via fc00:d::1
    run ip netns exec host4 ip -6 route add fc00:13::/64 via fc00:d::1
    run ip netns exec host4 ip -6 route add fc00:34::/64 via fc00:d::1
    run ip netns exec host4 ip -6 route add fc00:45::/64 via fc00:d::1

    # router4 configuration
    run ip netns exec router4 ip link set lo up
    run ip netns exec router4 ip link set veth-rt4-h4 up
    run ip netns exec router4 ip addr add fc00:d::1/64 dev veth-rt4-h4

    # sysctl for router4
    ip netns exec router4 sysctl net.ipv6.conf.all.forwarding=1
    ip netns exec router4 sysctl net.ipv6.conf.all.seg6_enabled=1
}

create_router5 () {
    # setup namespaces
    run ip netns add host5
    run ip netns add router5

    # setup veth peer
    run ip link add veth-h5-rt5 type veth peer name veth-rt5-h5
    run ip link set veth-h5-rt5 netns host5
    run ip link set veth-rt5-h5 netns router5

    # host5 configuration
    run ip netns exec host5 ip link set lo up
    run ip netns exec host5 ip link set veth-h5-rt5 up
    run ip netns exec host5 ip addr add fc00:e::2/64 dev veth-h5-rt5
    run ip netns exec host5 ip -6 route add fc00:a::/64 via fc00:e::1
    run ip netns exec host5 ip -6 route add fc00:b::/64 via fc00:e::1
    run ip netns exec host5 ip -6 route add fc00:c::/64 via fc00:e::1
    run ip netns exec host5 ip -6 route add fc00:d::/64 via fc00:e::1
    run ip netns exec host5 ip -6 route add fc00:12::/64 via fc00:e::1
    run ip netns exec host5 ip -6 route add fc00:25::/64 via fc00:e::1
    run ip netns exec host5 ip -6 route add fc00:13::/64 via fc00:e::1
    run ip netns exec host5 ip -6 route add fc00:34::/64 via fc00:e::1
    run ip netns exec host5 ip -6 route add fc00:45::/64 via fc00:e::1

    # router5 configuration
    run ip netns exec router5 ip link set lo up
    run ip netns exec router5 ip link set veth-rt5-h5 up
    run ip netns exec router5 ip addr add fc00:e::1/64 dev veth-rt5-h5

    # sysctl for router5
    ip netns exec router5 sysctl net.ipv6.conf.all.forwarding=1
    ip netns exec router5 sysctl net.ipv6.conf.all.seg6_enabled=1
}

create_router5_only_router5 () { # fc00:e::/64
    # setup namespaces
    run ip netns add router5

    # router5 configuration
    run ip netns exec router5 ip link set lo up

    # sysctl for router5
    ip netns exec router5 sysctl net.ipv6.conf.all.forwarding=1
    ip netns exec router5 sysctl net.ipv6.conf.all.seg6_enabled=1
}

connect_rt1_rt2 () {
    # create veth peer
    run ip link add veth-rt1-rt2 type veth peer name veth-rt2-rt1
    run ip link set veth-rt1-rt2 netns router1
    run ip link set veth-rt2-rt1 netns router2

    # configure router1
    run ip netns exec router1 ip link set veth-rt1-rt2 up
    run ip netns exec router1 ip addr add fc00:12::1/64 dev veth-rt1-rt2
    run ip netns exec router1 ip -6 route add fc00:b::/64 via fc00:12::2
    run ip netns exec router1 ip -6 route add fc00:e::/64 via fc00:12::2
    run ip netns exec router1 ip -6 route add fc00:25::/64 via fc00:12::2

    # configure router2
    run ip netns exec router2 ip link set veth-rt2-rt1 up
    run ip netns exec router2 ip addr add fc00:12::2/64 dev veth-rt2-rt1
    run ip netns exec router2 ip -6 route add fc00:a::/64 via fc00:12::1
}

connect_rt2_rt5 () {
    # create veth peer
    run ip link add veth-rt2-rt5 type veth peer name veth-rt5-rt2
    run ip link set veth-rt2-rt5 netns router2
    run ip link set veth-rt5-rt2 netns router5

    # configure router2
    run ip netns exec router2 ip link set veth-rt2-rt5 up
    run ip netns exec router2 ip addr add fc00:25::1/64 dev veth-rt2-rt5
    run ip netns exec router2 ip -6 route add fc00:e::/64 via fc00:25::2

    # configure router5
    run ip netns exec router5 ip link set veth-rt5-rt2 up
    run ip netns exec router5 ip addr add fc00:25::2/64 dev veth-rt5-rt2
    run ip netns exec router5 ip -6 route add fc00:a::/64 via fc00:25::1
    run ip netns exec router5 ip -6 route add fc00:b::/64 via fc00:25::1
}

connect_rt1_rt3 () {
    # create veth peer
    run ip link add veth-rt1-rt3 type veth peer name veth-rt3-rt1
    run ip link set veth-rt1-rt3 netns router1
    run ip link set veth-rt3-rt1 netns router3

    # configure router1
    run ip netns exec router1 ip link set veth-rt1-rt3 up
    run ip netns exec router1 ip addr add fc00:13::1/64 dev veth-rt1-rt3
    run ip netns exec router1 ip -6 route add fc00:34::/64 via fc00:13::2
    run ip netns exec router1 ip -6 route add fc00:45::/64 via fc00:13::2
    run ip netns exec router1 ip -6 route add fc00:c::/64 via fc00:13::2
    run ip netns exec router1 ip -6 route add fc00:d::/64 via fc00:13::2

    # configure router3
    run ip netns exec router3 ip link set veth-rt3-rt1 up
    run ip netns exec router3 ip addr add fc00:13::2/64 dev veth-rt3-rt1
    run ip netns exec router3 ip -6 route add fc00:a::/64 via fc00:13::1
}

connect_rt3_rt4 () {
    # create veth peer
    run ip link add veth-rt3-rt4 type veth peer name veth-rt4-rt3
    run ip link set veth-rt3-rt4 netns router3
    run ip link set veth-rt4-rt3 netns router4

    # configure router3
    run ip netns exec router3 ip link set veth-rt3-rt4 up
    run ip netns exec router3 ip addr add fc00:34::1/64 dev veth-rt3-rt4
    run ip netns exec router3 ip -6 route add fc00:45::/64 via fc00:34::2
    run ip netns exec router3 ip -6 route add fc00:d::/64 via fc00:34::2
    run ip netns exec router3 ip -6 route add fc00:e::/64 via fc00:34::2

    # configure router4
    run ip netns exec router4 ip link set veth-rt4-rt3 up
    run ip netns exec router4 ip addr add fc00:34::2/64 dev veth-rt4-rt3
    run ip netns exec router4 ip -6 route add fc00:a::/64 via fc00:34::1
    run ip netns exec router4 ip -6 route add fc00:c::/64 via fc00:34::1
}

connect_rt4_rt5 () {
    # create veth peer
    run ip link add veth-rt4-rt5 type veth peer name veth-rt5-rt4
    run ip link set veth-rt4-rt5 netns router4
    run ip link set veth-rt5-rt4 netns router5

    # configure router4
    run ip netns exec router4 ip link set veth-rt4-rt5 up
    run ip netns exec router4 ip addr add fc00:45::1/64 dev veth-rt4-rt5
    run ip netns exec router4 ip -6 route add fc00:e::/64 via fc00:45::2

    # configure router5
    run ip netns exec router5 ip link set veth-rt5-rt4 up
    run ip netns exec router5 ip addr add fc00:45::2/64 dev veth-rt5-rt4
    run ip netns exec router5 ip -6 route add fc00:c::/64 via fc00:45::1
    run ip netns exec router5 ip -6 route add fc00:d::/64 via fc00:45::1
    # veth-rt2-rt5の設定と重複しているため
    # run ip netns exec router5 ip -6 route add fc00:a::/64 via fc00:45::1
}

destroy_network () {
    run ip netns del router1
    run ip netns del router2
    run ip netns del router3
    run ip netns del router4
    run ip netns del router5
    run ip netns del host1
    run ip netns del host2
    run ip netns del host3
    run ip netns del host4
    run ip netns del host5
}

stop () {
    destroy_network
}

# exec functions
create_router1
create_router2
create_router3
create_router4
create_router5

connect_rt1_rt2
connect_rt2_rt5
connect_rt1_rt3
connect_rt3_rt4
connect_rt4_rt5

status=0; $SHELL || status=$?
exit $status

