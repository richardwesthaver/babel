#!/bin/sh
curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly
source $HOME/.cargo/env
# apt install build-essential git curl cmake gcc g++ pkg-config libmagic-dev libssl-dev zlib1g-dev postgresql lxc-utils
adduser --disabled-login --disabled-password --gecos "" docs
echo 'docs  ALL=(ALL) NOPASSWD: /usr/bin/lxc-attach' > /etc/sudoers.d/docs

mkdir /docs
chown docs:docs /docs

sudo -u docs mkdir -vp /docs/yi-prefix/documentations /docs/public_html /docs/sources
sudo -u docs git clone https://github.com/rust-lang/crates.io-index.git /docs/crates.io-index
sudo -u docs git --git-dir=/docs/crates.io-index/.git branch crates-index-diff_last-seen

LANG=C lxc-create -n docs-container -P /docs -t download -- --dist ubuntu --release bionic --arch amd64
ln -s /docs/container /var/lib/lxc
chmod 755 /docs/container
chmod 755 /var/lib/lxc

echo 'USE_LXC_BRIDGE="true"
LXC_BRIDGE="lxcbr0"
LXC_ADDR="10.0.3.1"
LXC_NETMASK="255.255.255.0"
LXC_NETWORK="10.0.3.0/24"
LXC_DHCP_RANGE="10.0.3.2,10.0.3.254"
LXC_DHCP_MAX="253"
LXC_DHCP_CONFILE=""
LXC_DOMAIN=""' > /etc/default/lxc-net

echo 'lxc.net.0.type = veth
lxc.net.0.link = lxcbr0' > /docs/container/config

systemctl restart lxc-net
systemctl enable lxc@docs-container.service
systemctl start lxc@docs-container.service

lxc-attach -n docs-container -- apt update
lxc-attach -n docs-container -- apt upgrade
lxc-attach -n docs-container -- apt install curl ca-certificates binutils gcc libc6-dev libmagic1 pkg-config build-essential

lxc-attach -n docs-container -- adduser --disabled-login --disabled-password --gecos "" docs
lxc-attach -n docs-container -- su - docs -c 'curl https://sh.rustup.rs -sSf | sh -s -- -y --default-toolchain nightly'
lxc-attach -n docs-container -- su - docs -c 'rustup target add i686-apple-darwin'
lxc-attach -n docs-container -- su - docs -c 'rustup target add i686-pc-windows-msvc'
lxc-attach -n docs-container -- su - docs -c 'rustup target add i686-unknown-linux-gnu'
lxc-attach -n docs-container -- su - docs -c 'rustup target add x86_64-apple-darwin'
lxc-attach -n docs-container -- su - docs -c 'rustup target add x86_64-pc-windows-msvc'

for directory in .cargo .rustup .multirust; do  [[ -h /home/docs/$directory ]] || sudo -u docs ln -vs /var/lib/lxc/docs-container/rootfs/home/docs/$directory /home/docs/; done

echo 'CRATESFYI_PREFIX=/cratesfyi-prefix
DOCS_DATABASE_URL=postgresql://docs:hackme@localhost #@replace
DOCS_CONTAINER_NAME=cratesfyi-container
DOCS_GITHUB_USERNAME=
DOCS_GITHUB_ACCESSTOKEN=
RUST_LOG=docs' > /home/docs/.docs.env

echo 'export $(cat $HOME/.docs.env | xargs -d "\n")
export PATH="$HOME/.cargo/bin:$PATH"
export PATH="$PATH:$HOME/docs.rs/target/release"' > /home/docs/.profile

sudo -u docs git clone https://github.com/rust-lang-nursery/docs.rs.git ~docs/docs.rs
sudo su - docs -c 'cd ~/docs.rs && cargo build --release'
cp -v /home/docs/docs.rs/target/release/docs /var/lib/lxc/docs-container/rootfs/usr/local/bin

sudo -u postgres sh -c "psql -c \"CREATE USER docs WITH PASSWORD 'hackme';\""
sudo -u postgres sh -c "psql -c \"CREATE DATABASE docs OWNER docs;\""
sudo su - docs -c "cd ~/docs.rs && cargo run --release -- database init"
sudo su - docs -c "cd ~/docs.rs && cargo run --release -- build add-essential-files"
sudo su - docs -c "cd ~/docs.rs && cargo run --release -- build crate rand 0.5.5"
sudo su - docs -c "cd ~/docs.rs && cargo run --release -- database update-search-index"
sudo su - docs -c "cd ~/docs.rs && cargo run --release -- database update-release-activity"

echo '[Unit]
Description=Docs daemon
After=network.target postgresql.service

[Service]
User=docs
Group=docs
Type=forking
PIDFile=/docs/docs.pid
EnvironmentFile=/home/docs/.docs.env
ExecStart=/home/docs/docs.rs/target/release/docs daemon
WorkingDirectory=/home/docs/docs.rs

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/docs.service
