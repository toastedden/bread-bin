# The Bread Bin

This repository contains all the small `.sh` scripts I used to set up my Raspberry Pi Zero 2 W cluster to host my [website](https://github.com/toastedden/toasted-den-website), [discord bot](https://github.com/toastedden/toastbot), and a few other projects.

![The Bread Bin](https://github.com/user-attachments/assets/d69abafc-4ee8-4701-b173-ad02eb2671e5)

## Using the Scripts

To use these scripts:

1. Download the desired script.
2. Make it executable and run it:
```bash
sudo chmod +x {install}.sh
./{install}.sh
```

**Note**: These scripts assume you are using a 64-bit ARM processor.

Some scripts use `cloudflared`. Replace `TOKEN` with your own token from Cloudflare where applicable.

## Pi Cluster List

1. **Master Pi**  
   Hosts the master Portainer container, allowing the other Pis in the cluster to connect.

2. **ToastBot Pi**  
   Runs my Discord bot, [ToastBot](https://github.com/toastedden/toastbot), along with a corresponding web server in Docker.

3. **Toasted Den Website Pi**  
   Hosts my [website](https://toastedden.com/) in a Docker container using `cloudflared`.

Thank you *Alice* for helping me put the cluster together!
