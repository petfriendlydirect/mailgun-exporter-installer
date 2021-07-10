#!/bin/sh -e
_check_root () {
    if [ $(id -u) -ne 0 ]; then
        echo "Please run as root" >&2;
        exit 1;
    fi
}

_check_root

if [ ! -f /opt/mailgun-exporter/mailgun-exporter ]; then
    echo "You need to build and install the mailgun-exporter binary first."
fi

mkdir -p /etc/mailgun_exporter
if [ ! -f /etc/mailgun_exporter/datasource ]; then
    echo "MG_API_KEY=XXXXXXX" > /etc/mailgun_exporter/datasource
    echo "Please update /etc/mailgun_exporter/datasource with a valid API key from mailgun"
fi

if [ -x "$(command -v systemctl)" ]; then
    cat << EOF > /lib/systemd/system/mailgun-exporter.service
[Unit]
Description=Prometheus agent
After=network.target
StartLimitIntervalSec=0

[Service]
EnvironmentFile=/etc/mailgun_exporter/datasource
Type=simple
Restart=always
RestartSec=1
ExecStart=/opt/mailgun-exporter/mailgun-exporter

[Install]
WantedBy=multi-user.target
EOF

    systemctl enable mailgun-exporter
elif [ -x "$(command -v chckconfig)" ]; then
    cat << EOF >> /etc/inittab
::respawn:/opt/mailgun-exporter/mailgun-exporter
EOF
elif [ -x "$(command -v initctl)" ]; then
    cat << EOF > /etc/init/mailgun-exporter.conf
start on runlevel [23456]
stop on runlevel [016]
exec /opt/mailgun-exporter/mailgun-exporter
respawn
EOF

    initctl reload-configuration
    stop mailgun-exporter || true
else
    echo "No known service management found" >&2;
    exit 1;
fi
