# == Resource: openvpn::config::client
#
# Generates the certificate and key files for the client to connect.
#
# Parameters:
# * *server*: What server configuration to use. Use the $name you defined in openvpn::config::server when created. Required.
#
define openvpn::config::client (
    $server
) {

    exec { "generate-client-$name":
        command  => ". ./vars && KEY_CN=client-${name} ./pkitool client-${name}",
        cwd      => "/etc/openvpn/${server}/easy-rsa",
        creates  => "/etc/openvpn/${server}/easy-rsa/keys/client-${name}.crt",
        provider => 'shell',
        require  => Openvpn::Config::Easyrsa[$server];
    }
}
