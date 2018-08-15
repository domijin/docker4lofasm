# docker4lofasm
Setup Dev Environment for LOFASM with Docker

__First step__: signup and install [Docker](http://docker.com/) based on the operation system. Proceed when it's running. 

## Command to fire up the lofasm environment

```bash
# 1. clone this repository 
git clone https://github.com/domijin/docker4lofasm.git && cd docker4lofasm

# 2. build up from the Dockerfile
docker build -t lofasm_py2 .  # change the name lofasm_py2 as you wish

# 3.1 run as detached server, if you are more comfortable with terminal
# add '--rm' if do not want to save changes
docker run -d -p 2222:22 -v data_dir/in/host:/data_dir/in/container lofasm_py2
ssh -p 2222 lof@localhost  # default password: lof

# 3.2 run in desktop mode, using vnc, follow the guide to create vnc password
docker run -it -p 5901:5901 -v data_dir/in/host:/data_dir/in/container -e USER=lof lofasm_py2 bash -c "vncserver :1 -geometry 1280x800 -depth 24 && tail -F ~/.vnc/*.log"
# then use vnc viewer to access vnc://localhost:5901 with the password you set
# for mac, use Screen Sharing.app, type in 'vnc://localhost:5901' to start

# 3.3 run in interactive way, the data files will be shared and the container will burn once exit (--rm), su password is 'Docker!'
docker run -it --rm -v data_dir/in/host:/data_dir/in/container -e USER=lof --user=lof lofasm_py2 bash


# 3.4 install & start a Jupyter Notebook server and interact via your browser, modify the port based on your case
docker run -it -p 8888:8888 lofasm_py2 bash -c "/opt/conda/bin/conda install jupyter -y --quiet && mkdir /opt/notebooks && /opt/conda/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='*' --port=8888 --no-browser"`
# the Jupyter Notebook can be fired up at 'http://localhost:8888' in your browser
```


## Other Basic Docker Instructions

```bash
docker build [--no-cache] -t img_name path/to/Dockerfile  # build image based on dockerfile
docker images  # pulled images
docker ps [-a]  # show running containers

docker start/attach con_id  # restart excited container
       stop con_id  # stop container
       rm con_id  # rm container
       rmi img_id  # rm image
       
docker run -d -p 2222:22 <Image Name>

docker run -it  # interactive
           --rm  # rm container when exit, use with caution
           -d  # detached
           -p 8888:80  # port fwd to host
           -e DISPLAY=$DISPLAY  # set environment variable
           -u docker  # username/uid
           -v <data_location>:~/data  # mount data directory
           --name="rdev"  # container name
           ubuntu  # image name
           bash  # command

docker port con_id  # show port fwd
ssh -p 2222 root@localhost

docker cp local_file con_id:path/to/target  # copy file to container
```

Have fun!
