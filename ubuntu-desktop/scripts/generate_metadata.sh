#!/bin/bash

set -e

CONFIG=config.yaml

NAME=$(yq -r '.ubu.vm.name' $CONFIG)
HOST_NAME=$(yq -r '.ubu.system.hostname' $CONFIG)
INDEX=$(yq -r '.ubu.web.index_file' $CONFIG)

TIMEZONE=$(yq -r '.ubu.system.timezone' $CONFIG)
LOCALE=$(yq -r '.ubu.system.locale' $CONFIG)
KEYBOARD=$(yq -r '.ubu.system.keyboard' $CONFIG)


WORKDIR="./build-$NAME"
mkdir -p $WORKDIR



#Encodovani index.html pro nahrani na VM "na prase"
INDEX_CONTENT=$(base64 -w0 "$INDEX")

# Parsovani uzivatelu do user-data. Prnvi je primarni do identity, zbytek je obycejni users
PRIMARY_USER=$(yq -r '.ubu.users[0].username' $CONFIG)
PRIMARY_PASS=$(yq -r '.ubu.users[0].password' $CONFIG)

USER_BLOCK=""
USER_COUNT=$(yq -r '.ubu.users | length' $CONFIG)

for ((i=0;i<$USER_COUNT;i++)); do
U=$(yq -r ".ubu.users[$i].username" $CONFIG)
P=$(yq -r ".ubu.users[$i].password" $CONFIG)
SUDO=$(yq -r ".ubu.users[$i].sudo" $CONFIG)
if [ "$SUDO" = "true" ]; then
GROUPS="sudo"
else
GROUPS=""
fi

#Vyplnene promenne prilepim na konec bloku s uzivateli
USER_BLOCK="$USER_BLOCK
    - name: $U
      groups: $GROUPS
      lock_passwd: false
      passwd: $P
      shell: /bin/bash"

done

##Parsovani balicku k instalaci:
PACKAGES_BLOCK=""
PACKAGES_COUNT=$(yq -r '.ubu.packages | length' $CONFIG)

for ((i=0;i<$PACKAGES_COUNT;i++)); do
PACKAGE=$(yq -r ".ubu.packages[$i]" $CONFIG)
PACKAGES_BLOCK="$PACKAGES_BLOCK
    - $PACKAGE
    "

done

# Vytvoreni souboru potrebnych pro vytvoreni seed.iso: user-data a meta-data
# Meta-data je statické:

cat > $WORKDIR/meta-data <<EOF
instance-id: $NAME
local-hostname: $HOST_NAME
EOF

# User-data je slozitejsi:
cat > $WORKDIR/user-data <<EOF
#cloud-config
autoinstall:
  version: 1

  identity:
    hostname: $HOST_NAME
    username: $PRIMARY_USER
    password: $PRIMARY_PASS

  locale: $LOCALE

  keyboard:
    layout: $KEYBOARD

  timezone: $TIMEZONE

  ssh:
    install-server: true
    allow-pw: true

  storage:
    layout:
      name: direct

  packages:
$PACKAGES_BLOCK

  user-data:
    users:
$USER_BLOCK

  ssh_pwauth: true
    
  write_files:
    - path: /var/www/html/index.html
      permissions: '0644'
      encoding: b64
      content: $INDEX_CONTENT

  runcmd:
    - apt install apache2 -y
    - systemctl enable apache2
    - systemctl restart apache2
    - systemctl enable qemu-guest-agent
EOF

# Z user-data a meta-data kompiluji seed.iso s autoinstalacni konfiguraci
echo "Creating seed ISO..."

cloud-localds $WORKDIR/seed.iso \
 $WORKDIR/user-data \
 $WORKDIR/meta-data
