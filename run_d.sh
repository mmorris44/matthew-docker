#!/bin/bash
# Will detach the container and print container ID

hs=`hostname`
hs=${hs//.cs.ox.ac.uk/}

# choices: default, mujoco131, mujoco150, mujoco200
dockerfile=$1
shift

# Build the docker image, if available with nvidia-docker
if hash nvidia-docker 2>/dev/null; then
    gpu=$1
    shift
    NV_GPU="$gpu" nvidia-docker run -d --rm -ti \
            --net host \
            -v /data/${hs}/${USER}/:/users/${USER}/data/ \
            -v /users/${USER}/BAIML:/users/${USER}/BAIML \
            -v /users/${USER}/rl_duq:/users/${USER}/rl_duq \
            -v /users/${USER}/vate:/users/${USER}/vate \
            --env PYTHONPATH="/users/${USER}/BAIML:/users/${USER}/rl_duq:/users/${USER}/rl_duq/gpduq:/users/${USER}/vate" \
            ${USER}/${dockerfile} \
            $@
else
    cpuset=$1
    shift
    docker run -d --rm -ti --cpuset-cpus "$cpuset"\
            --net host \
            -v /data/${hs}/${USER}/:/users/${USER}/data/ \
            -v /users/${USER}/BAIML:/users/${USER}/BAIML \
            -v /users/${USER}/rl_duq:/users/${USER}/rl_duq \
            -v /users/${USER}/vate:/users/${USER}/vate \
            --env PYTHONPATH="/users/${USER}/BAIML:/users/${USER}/rl_duq:/users/${USER}/rl_duq/gpduq:/users/${USER}/vate" \
            ${USER}/${dockerfile} \
            $@
fi
