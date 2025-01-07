# Homebrew + conda
## Getting Homebrew
Run `/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"`

## Getting PX4 and Gazebo-classic
More info in [PX4 MacOS Setup guide](https://docs.px4.io/main/en/dev_setup/dev_env_mac.html)
1. Increases the maximum number of open files: `echo ulimit -S -n 2048 >> ~/.zshenv` 
2. Create a virtual environment for all the python dependencies: `python3.11 -m venv .venv && source .venv/bin/activate`. If you don't have python3.11, install it with: `brew install python@3.11`
3. Get the PX4 repository: `git clone https://github.com/PX4/PX4-Autopilot.git --recursive`
4. Install general tools: `pip install pyserial empty toml numpy pandas jinja2 pyyaml pyros-genmsg packaging kconfiglib future jsonschema`
5. Install the PX4 toolchain:
    ```
    cd PX4-Autopilot
    pip install -r Tools/setup/requirements.txt
    brew tap PX4/px4
    brew install px4-dev px4-sim
    ```
6. First confirm you have gazebo-classic: `gazebo --version`
7. Confirm everything work: in the PX4 root directory, run `make px4_sitl gazebo-classic`

Potential problems:
- **Problem**: `make px4_sitl gazebo-classic` throws an error involving the qt library. This is due to two conflicting qt libraries.

  **Solution**: Set the following environment variables for cmake and pkg-config to find the proper qt library: 
    ```
    export CMAKE_PREFIX_PATH="$CMAKE_PREFIX_PATH:/opt/homebrew/opt/qt@6" 
    export PKG_CONFIG_PATH="$PKG_CONFIG_PATH:/opt/homebrew/opt/qt@5/lib/pkgconfig"
    ```
  _OR_ if the above doesn't work: Remove one of them: `brew uninstall --ignore-dependencies qt` and try to make again. If the error persist, reinstall it (`brew install qt`) and remove the other (`brew uninstall --ignore-dependencies qt@5`).

- **Problem**: `make px4_sitl gazebo-classic` is missing some dependencies (e.g. OGRE node found)

  **Solution**: install them with brew: `brew install ogre`


## Getting Miniconda
Miniconda will be the package manager for installing ROS2
1. Install it `brew install --cask miniconda`
2. Initialize it: `conda init "$(basename "${SHELL}")"`, restart the terminal.
3. Create the ROS environment: `conda create -n ros_env python=3.11 && conda activate ros_env`
4. You are now ready to install the rest.

## Getting ROS2
More info in [RoboStack installation guide](https://robostack.github.io/GettingStarted.html)
1. Activate the ros_env conda env.
2. Get ROS2: `conda install --override-channels -c conda-forge -c robostack-staging ros-humble-desktop -y`
3. Reactivate the env to initialize the ROS2 env: 

        conda deactivate
        conda activate ros_env

4. Install development tools for ROS2: `conda install compilers cmake pkg-config make ninja colcon-common-extensions catkin_tools rosdep`

## How to use
The PX4 toolchain and gazebo must in the same environment. In other words, they must both be installed with homebrew for their dependencies be resolved correctly. This means to NOT run `make px4_sitl gazebo-classic` in the ros_env because they are no longer in their original environment. In a terminal, activate the python virtual environment that you used to install px4, then you can make gazebo. To use ROS2, in a separate terminal activate the conda environment to have the ROS toolchain.
