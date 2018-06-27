# docker4lofasm
Setup Dev Environment for LOFASM with Docker

## Command to fire and work

```bash
docker build -t lofasm_py2 .

# run as detached server
docker run -d -p 2222:22 -v data_dir/in/host:/data_dir/in/container lofasm_py2
# ssh in, default password: psr
ssh -p 2222 lof@localhost

# or run in desktop mode, with vnc, add '--rm' if just exploring
docker run -it -p 5901:5901 -v data_dir/in/host:/data_dir/in/container -e USER=lof lofasm_py2 bash -c "vncserver :1 -geometry 1280x800 -depth 24 && tail -F ~/.vnc/*.log"
# then use vnc viewer to access vnc://localhost:5901 with the password you set

# or run in interactive way, the data files will be shared and the container will burn once exit (--rm), su password is 'Docker!'
docker run -it --rm -v data_dir/in/host:/data_dir/in/container -e USER=lof --user=lof lofasm_py2 bash
```

You can install & start a Jupyter Notebook server and interact via your browser:

`docker run -it -p 8888:8888 lofasm_py2 bash -c "/opt/conda/bin/conda install jupyter -y --quiet && mkdir /opt/notebooks && /opt/conda/bin/jupyter notebook --notebook-dir=/opt/notebooks --ip='*' --port=8888 --no-browser"`

You can then view the Jupyter Notebook by opening `http://localhost:8888` in your browser, or `http://<DOCKER-MACHINE-IP>:8888` if you are using a Docker Machine VM.


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
