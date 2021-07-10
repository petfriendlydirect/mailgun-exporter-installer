# mailgun-exporter-installer

Configure the [prometheus-mailgun-exporter](https://github.com/missionlane/prometheus-mailgun-exporter) binary for automatic startup (via systemd or upstart) on various platforms

## Usage

Download, build and install the mailgun exporter

( as root or prefix sudo as needed )
```bash
git clone https://github.com/missionlane/prometheus-mailgun-exporter.git
cd prometheus-mailgun-exporter
make prometheus-mailgun-exporter
mkdir -p /opt/mailgun-exporter
mv mailgun-exporter /opt/mailgun-exporter
```

Install the script

```bash
curl -sSL https://raw.githubusercontent.com/petfriendlydirect/mailgun-exporter-installer/master/bin/install.sh | sudo sh
```

Update the datasource file with the correct credentials

```bash
sudo vim /etc/mailgun_exporter/datasource
```

Start the service

```bash
sudo systemctl start mailgun-exporter
# or
sudo start mailgun-exporter
```

The metrics endpoint should now be available at http://localhost:9616
