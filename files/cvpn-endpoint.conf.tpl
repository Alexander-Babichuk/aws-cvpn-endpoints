client
dev tun
proto ${transport_protocol}
remote ${endpoint_dns_name} 443
remote-random-hostname
resolv-retry infinite
nobind
persist-key
persist-tun
remote-cert-tls server
cipher AES-256-GCM
verb 3

<ca>
${certificate_chain}
</ca>

<cert>
${certificate_body}
</cert>

<key>
${private_key_body}
</key>

reneg-sec 0
