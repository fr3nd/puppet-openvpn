# == Resource: openvpn::config::easyrsa
#
# Creates all the required certificates for the vpn to work
#
# Parameters:
# * *key_size*: Openssl key size. Default: 1024
# * *ca_expire*: In how many days should the root CA key expire? Default: 3650
# * *key_expire*: In how many days should certificates expire? Default: 3650
# * *key_country*: Certificate country. Required
# * *key_province*: Certificate province. Required
# * *key_city*: Certificate city. Required
# * *key_org*: Certificate organization. Required
# * *key_email*: Certificate email. Required
# * *key_cn*: Certificate CN. Default: $name
# * *key_name*: Certificate name. Default: $name
# * *key_ou*: Certificate OU. Default: $name
# * *pkcs11_module_path*: 
# * *pkcs11_pin*: 
#
define openvpn::config::easyrsa (
    $key_size = '1024',
    $ca_expire = '3650',
    $key_expire = '3650',
    $key_country,
    $key_province,
    $key_city,
    $key_org,
    $key_email,
    $key_cn = $name,
    $key_name = $name,
    $key_ou = $name,
    $pkcs11_module_path = 'changeme',
    $pkcs11_pin = '1234'
) {

    include openvpn
    realize Package['easy-rsa']

    exec { "copy-easy-rsa-${name}":
        command => "/bin/cp -ra /usr/share/easy-rsa/2.0 /etc/openvpn/${name}/easy-rsa",
        creates => "/etc/openvpn/${name}/easy-rsa",
        require => [ Package['easy-rsa'], File["/etc/openvpn/${name}"] ];
    }

    file { 
        "/etc/openvpn/${name}":
            ensure  => directory,
            mode    => '0755',
            require => Class['openvpn'];
        "/etc/openvpn/${name}/easy-rsa/vars":
            ensure  => present,
            mode    => '0755',
            content => template('openvpn/vars.erb'),
            require => Exec["copy-easy-rsa-${name}"];
    }

    Exec {
        path => [ '/sbin', '/bin', '/usr/sbin', '/usr/bin' ],
    }

    exec {
        "generate-ca-${name}":
            command  => '. ./vars && ./clean-all && ./pkitool --initca',
            cwd      => "/etc/openvpn/${name}/easy-rsa",
            creates  => "/etc/openvpn/${name}/easy-rsa/keys/ca.crt",
            provider => 'shell',
            require  => File["/etc/openvpn/${name}/easy-rsa/vars"];
        "generate-cert-${name}":
            command  => ". ./vars && ./pkitool --server server-${name}",
            cwd      => "/etc/openvpn/${name}/easy-rsa",
            creates  => "/etc/openvpn/${name}/easy-rsa/keys/server-${name}.crt",
            provider => 'shell',
            require  => Exec["generate-ca-${name}"];
        "generate-dh-${name}":
            command  => '. ./vars && ./build-dh',
            cwd      => "/etc/openvpn/${name}/easy-rsa",
            creates  => "/etc/openvpn/${name}/easy-rsa/keys/dh1024.pem",
            provider => 'shell',
            require  => Exec["generate-ca-${name}"];
    }
}
