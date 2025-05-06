GPG=hashicorp-archive-keyring.gpg
URL=https://apt.releases.hashicorp.com
TARGET=$(lsb_release -cs)
cat << EOS | sudo tee /etc/apt/sources.list.d/hashicorp.list
deb [signed-by=/usr/share/keyrings/${GPG}] ${URL} ${TARGET} main
EOS
