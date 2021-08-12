This repo contains Dockerfiles and run scripts tailored to the WhiRL servers.

### 1. Building Docker Images

There are four Dockerfiles: `Dockerfile`, `Dockerfile_mj131`, `Dockerfile_mj150`, `Dockerfile_mj200`. 
The last three include MuJoCo 131/150/200.
They can be used to build Docker images on GPU or CPU servers. 

If you want to add your own Python packages, do so in the Dockerfile you want to use (preferably adding to the `conda` or `pip` lines that exist already).

To build the docker image: On the server, from the folder containing the Dockerfile, run
```
bash build.sh Dockerfile_mj200
```
using the Dockerfile you want.
If you use one of the Dockerfiles containing MuJoCo, you need first add the MuJoCo key in the same folder, named `mjkey.txt`.

The user permissions will be automatically set for your user ID so that you don't run as root inside docker.
The docker image will be called `<user>/default` or `<user>/mujoco200` where `<user>` is your username (for me that's `luiraf`).

### 2. Run Experiments 

Before running experiments, you need to change the paths in the `run.sh` and `run_d.sh` files (replacing the lines containing `varibad`).
Your `data` folder will be automatically linked to `~/data/` inside docker, so you can reach it from your code.

T start an experiment, run 
```
docker/run.sh default 0 python ~/varibad/main.py
```

Where `default` is the docker container (other choices: `mujoco131`, `mujoco150`, `mujoco200`) and `0` is the GPU.
On a CPU server, indicate the CPUs like so: `0-4`.

User `run_d.sh` if you want the container to automatically detach and just print the container ID (useful for starting experiments in the background).
If you're running on CPU and don't want to restrict your experiments to a few CPUs, remove the `--cpuset` flag in the `run.sh` file.

### Check server status

- images that exist on server: `docker images`
- running docker containers: `docker ps`
- status of GPUs: `nvidia-smi`
- process 12345 on GPU: `ps aux | grep 12345`
- cpu usage: `htop`

### Notes

- `nvidia-docker run` is deprecated in docker 19.03, update once servers have updated it
- If you want to use tensorflow, add `tensorflow-gpu==1.14` to the conda install line; 
for this you need to use `cudatoolkit=10.1`
- If you have problems with the shared memory inside docker, add `--shm-size 32G` to the flags in the `run.sh` file.
- The flag `--net host` means ports inside the docker container can be accessed (useful e.g. when running tensorboard inside docker and looking at it locally via port forwarding)
- If you use the MuJoCo Ant environment, not that there's a bug in MuJoCo 200 which will zero out 80% of the input. Use MuJoCo 150 instead.

