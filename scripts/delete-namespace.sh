#!/bin/bash

if [[ $(id -u) -ne 0 ]] ; then
    echo "Please run with sudo"
    exit 1
fi

run () {
    echo "$@"
    "$@" || exit 1
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

destroy_network

