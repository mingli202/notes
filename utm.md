# Ubuntu setup on Arm Max

## Ubuntu VM
1. Download UTM from their [official website](https://mac.getutm.app/) (not on apple store)
2. Navigate to Ubuntu's 22.04 [download page](https://cdimage.ubuntu.com/releases/22.04/release/) and download the server image (Ubuntu 22.04.iso) for 64-bit ARMv8
3. Open UTM
4. Create a new virtual machine
5. Virtualize
6. Choose pre-configured Linux
7. Choose the Ubuntu 22.04 ISO for "Boot ISO Image". Leave all boxes unchecked.
8. For hardware, I recommend allocating half of your resources. E.g if you have 8G of ram and 8 CPU cores, then give the VM 4G and 4 CPU cores
9. Allocate at least 60 G of storage
10. Shared directory shares a local directory to the VM, allowing the VM to read/write to it. Can be omitted or leave it to the default Downloads folder.
11. Give it a meaningful name and click save.
12. Start the VM by clicked on the play button.
13. The Ubuntu setup will start.
14. Choose "Try or Install Ubuntu Server". It might take a while, and options will be given.
15. Arrows to select, space bar to toggle, and tab to navigate between options.
16. Choose your desired language.
17. Continue without updating because we want the 22.04 not the newer version.
18. Change the keyboard language and layout or leave it to the default English one.
19. Choose the Ubuntu Server base for installation. Not the minimized one. (press "Done")
20. Leave default for Network configuration (press "Done").
21. Leave default for Proxy configuration (press "Done").
22. Wait for mirror location to pass the tests, then press Enter.
23. Leave Guided storage configuration to default: press Tab to cycle through the options, then Enter on "Done".
24. Leave storage configuration to default: Press "Done" then "Continue" on the confirmation.
25. Profile configuration:
    - Your name: any name, it doesn't matter.
    - Your server name: name of your computer, doesn't matter, e.g. Ubuntu.
    - Username: IMPORTANT! This is the username of to your account. Remember it since Ubuntu will as you for it to login.  
    - Password: IMPORTANT! This is the password to your account and administration privilege. Ubuntu and your terminal will ask you for it.
26. No need Ubuntu Pro.
27. No need OpenSSH server.
28. No need any server snap.
29. Ubuntu is being configured, wait for it to finish.
30. Shut down the VM (not reboot).
31. Select the VM inn UTM
32. Click on CD/DVD and clear it. This will ensure the VM doesn't boot in configuration mode since we just did that.
33. Start the VM. It will say BdsExe failed and a bunch or errors, but that's normal.
34. Wait a bit and a terminal asking for your Ubuntu login should pop up.
35. Enter your username and password. If you forgot, delete the VM and restart.
36. Run `sudo apt update && sudo apt upgrade -y`. This will make the package manager's repository up to date. Note that `sudo` will ask for your password.
37. Run `sudo apt install ubuntu-desktop -y`. This will install the Ubuntu GUI. It will take a while.
38. Run `reboot`. This will reboot the system and launch the Ubuntu GUI.

## Gazebo classic installation
39. Open a terminal.
40. Install miniconda with
```
mkdir -p ~/miniconda3
wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-aarch64.sh -O ~/miniconda3/miniconda.sh
bash ~/miniconda3/miniconda.sh -b -u -p ~/miniconda3
rm ~/miniconda3/miniconda.sh
```
41. Run `echo 'eval "$(~/miniconda3/bin/conda shell.bash hook)"' >> .bashrc`. This adds miniconda to your $PATH.
42. Run  `source .bashrc`. This updates the environment.
43. Follow the Wiki to get gazebo:
```
conda create -n ros_env && conda activate ros_env
conda config --env --add channels conda-forge
conda config --env --add channels robostack-staging
conda config --env --remove channels defaults
conda install gazebo -y
```
44. Confirm you have gazebo by running `gazebo --version`.

## PX4 toolchain setup
45. Open a terminal
46. Run `git clone https://github.com/PX4/PX4-Autopilot.git --recursive`
47. Run bash `./PX4-Autopilot/Tools/setup/ubuntu.sh --no-nuttx --no-sim-tools`
48. Remove the default gazebo installation with `sudo apt remove ga-harmonic`
48. Confirm the installation with
