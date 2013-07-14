Puppet openvpn module
=====================

Description
-----------

Puppet module to manage an openvpn server installation. It will install,
configure the openvpn installation. It will also create all the required server
certificates and the client ones if necesary.


Usage
-----

The module is divided in several classes and defined resources. Many setups
can be created to have many different vpn profiles in the same server. Just
use different "server" resources using different names.

### class openvpn

This is the main class and it's required by the other ones. You need to include
it in your manifests.

### resource openvpn::config::server

Configures the server and setups all the required configuration parameters to
define the VPN.

### resource openvpn::config::easyrsa

It will generate all the server certificates required for the openvpn daemon
to start.

If this is not included, all the certificates need to be copied manually and
the server needs to be configured to use them.

### resource openvpn::config::client

Generates a client key pair. This key pair can be copied to a client so it can
connect to the vpn server. After the kyes have been copied to the client, the
private one can be deleted from the server.

Examples
--------

<pre>
class { 'openvpn': }

openvpn::config::easyrsa { 'example-server':
    key_country  => 'ES',
    key_province => 'CA',
    key_city     => 'Barcelona',
    key_org      => 'fr3nd.net',
    key_email    => 'test@test.net',
}

openvpn::config::server { 'example-server': }

openvpn::convig::client { 'username':
    server => 'example-server',
}
</pre>

Authors
-------

* Carles Amigó <fr3nd@fr3nd.net>

License
-------

    Author:: Carles Amigo (<fr3nd@fr3nd.net>)
    Copyright:: Copyright (c) 2012 Carles Amigo
    License:: Apache License, Version 2.0

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
