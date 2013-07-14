# == Resource: openvpn::config::server
#
# Configures a vpn server. None of the parameters is mandatory.
#
# Parameters:
# * *local*: Which local IP address should OpenVPN listen on? (optional)
# * *port*: Which TCP/UDP port should OpenVPN listen on? Default: 1194
# * *proto*: TCP or UDP server? Default: udp
# * *dev*: 'tun' will create a routed IP tunnel, 'tap' will create an ethernet tunnel. Default: tun
# * *ca*: Path to the ca.crt file
# * *cert*: Path to the server cert file
# * *key*: Path to the server key file
# * *dh*: Path to the Diffie hellman file
# * *server_subnet*: Subnet to be used. Default: 10.8.0.0
# * *server_netmask*: Netmask for the used subnet. Default: 255.255.255.0
# * *ifconfig_pool_persist*: File to be used for the client-virtual ip list
# * *server_bridge_ip*: Ip for the bridge. Default: 10.8.0.4
# * *server_bridge_netmask*: Netmask for the bridge. Default: 255.255.255.0
# * *server_bridge_subnet_start*: Ip where to start the subnet in bridge mode. Default: 10.8.0.50
# * *server_bridge_subnet_end*: Ip where to end the subnet in bridge mode. Default: 10.8.0.100
# * *push*: List of parameters to push to the client. Example: 'route 192.168.10.0 255.255.255.0'
# * *client_to_client*: allow different clients to be able to "see" each other? Default: false
# * *keepalive*: Ping like keepalive parameters. Default: "10 120"
# * *cipher*: Cipher to use. Default: BF-CBC
# * *extra_parameters*: List of extra parameters to be added.
#
define openvpn::config::server (
    $local = undef,
    $port = '1194',
    $proto = 'udp',
    $dev = 'tun',
    $ca = "/etc/openvpn/${name}/easy-rsa/keys/ca.crt",
    $cert = "/etc/openvpn/${name}/easy-rsa/keys/server-${name}.crt",
    $key = "/etc/openvpn/${name}/easy-rsa/keys/server-${name}.key",
    $dh = "/etc/openvpn/${name}/easy-rsa/keys/dh1024.pem",
    $server_subnet = '10.8.0.0',
    $server_netmask = '255.255.255.0',
    $ifconfig_pool_persist = 'ipp.txt',
    $server_bridge_ip = '10.8.0.4',
    $server_bridge_netmask = '255.255.255.0',
    $server_bridge_subnet_start = '10.8.0.50',
    $server_bridge_subnet_end = '10.8.0.100',
    $push = [],
    $client_to_client = false,
    $keepalive = '10 120',
    $cipher = 'BF-CBC',
    $extra_parameters = []
) {

    realize Service['openvpn']

    file {
        "/etc/openvpn/${name}.conf":
            content => template('openvpn/server.conf.erb'),
            mode    => '0644',
            ensure  => present,
            notify  => Service['openvpn'],
    }

}
