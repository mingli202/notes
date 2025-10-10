# join_ip_domains.py
import csv
from collections import defaultdict

# load ip->domains
ip2dom = defaultdict(set)
with open("ip_domains.tsv", "r") as f:
    for ln in f:
        ln = ln.strip()
        if not ln:
            continue
        ip, dom = ln.split("\t", 1)
        ip2dom[ip].add(dom)

# print header + combined CSV
print("ip,bytes_sent,bytes_recv,bytes_total,domains")
with open("ip_bytes.csv") as f:
    reader = csv.reader(f)
    header = next(reader)  # skip header line if present
    for row in reader:
        ip, sent, recv, total = row
        domains = ";".join(sorted(ip2dom.get(ip, ["-"])))
        print(f'{ip},{sent},{recv},{total},"{domains}"')
