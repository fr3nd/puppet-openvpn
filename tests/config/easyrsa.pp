class { 'openvpn': }
openvpn::config::easyrsa { 'test':
    key_country   => 'EU',
    key_province => 'TE',
    key_city    => 'TestCity',
    key_org    => 'test',
    key_email => 'test@test.net',
}
