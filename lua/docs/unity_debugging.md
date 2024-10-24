 ## Prerequisites

 Have Unity, and neovim installed.

 ### 1. Install Debugger

You can use the Netcoredbg for both Windows and Ubuntu. Below are the installation steps for both platforms.

#### Ubuntu

```
sudo apt update
sudo apt install -y curl unzip
sudo mkdir -p /usr/local/debuggers/netcoredbg
curl -L https://github.com/Samsung/netcoredbg/releases/latest/download/netcoredbg-linux-amd64.tar.gz -o netcoredbg.tar.gz
sudo tar -xvf netcoredbg.tar.gz -C /usr/local/debuggers/netcoredbg
sudo chmod +x /usr/local/debuggers/netcoredbg/netcoredbg
rm netcoredbg.tar.gz
```
#### Windows

Open a Windows Powershell as Administrator.
```
mkdir 'C:\Program Files\debuggers'
cd 'C:\Program Files\debuggers'
Invoke-WebRequest https://github.com/Samsung/netcoredbg/releases/download/3.1.1-1042/netcoredbg-win64.zip -OutFile netcoredbg.zip
Expand-Archive netcoredbg.zip -DestinationPath "C:\Program Files\debuggers"
```

To be continued...
