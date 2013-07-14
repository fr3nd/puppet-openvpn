# == Class: openvpn
#
# Installs the openvpn package and setups some virtual resources 
# This class is required
#
class openvpn {

    package { 'openvpn':
        ensure => installed;
    }

    @package { 'easy-rsa':
        ensure => installed;
    }

    @service { 'openvpn':
        ensure => running,
        enable => true,
    }

}
