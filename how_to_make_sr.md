# Segment Routingを使ったIPv6のルーティング設定

## 1. SRv6の環境を作成する

```bash
ip netns exec router1 bash
# すでに設定されている経路を書き換えるため、一旦 fc00:c::/64 への経路を削除
ip netns exec router1 ip -6 route del fc00:e::/64
ip netns exec router1 ip -6 route add fc00:e::/64 encap seg6 mode encap segs fc00:c::2 dev veth-rt1-h1
```

```bash
ip netns exec router1 ip -6 route show
```

```bash
# ip netns exec host1 bash <- 対処のhostに入ろう
ip netns exec host3 bash
tcpdump -i veth-h3-rt3 -w seg8.pcap
````

opening another terminal

```bash
ip netns exec host1 ping6 -c 3 fc00:e::2
```
