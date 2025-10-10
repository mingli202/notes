# pcap_ip_bytes.py - top senders / receivers (captured bytes)
from scapy.all import RawPcapReader, Ether, IP, IPv6
from collections import defaultdict
import sys

if len(sys.argv) != 2:
    print("Usage: pcap_ip_bytes.py <file.pcap>")
    sys.exit(1)

pcap = sys.argv[1]
sent = defaultdict(int)
recv = defaultdict(int)
total = 0

for pkt_data, _meta in RawPcapReader(pcap):
    total += len(pkt_data)
    try:
        eth = Ether(pkt_data)
    except Exception:
        continue
    if IP in eth:
        ip = eth[IP]
        src, dst = ip.src, ip.dst
    elif IPv6 in eth:
        ip = eth[IPv6]
        src, dst = ip.src, ip.dst
    else:
        continue
    sent[src] += len(pkt_data)
    recv[dst] += len(pkt_data)


def top(d, n=10):
    return sorted(d.items(), key=lambda x: x[1], reverse=True)[:n]


print(f"Total captured bytes: {total}  (bits: {total * 8})\n")
print("Top senders (bytes):")
for ip, b in top(sent, 20):
    print(f"{ip:40} {b:12} bytes  {b * 8:12} bits")
print("\nTop receivers (bytes):")
for ip, b in top(recv, 20):
    print(f"{ip:40} {b:12} bytes  {b * 8:12} bits")
