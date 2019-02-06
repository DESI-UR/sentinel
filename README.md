# sentinel

This is a project to control the number of jobs to be submitted to slurm batch system.

After cloning the project, user needs to create three directories:
- queue
- run
- complete

These directories will be used for pushing the jobs into slurm queue properly.

Once these directories are set, user needs to start the sentinel. That can be done either by adding a line in crontab or running it interactively at the background. For the latter, the following line should executed in the sentinel main directory:

nohup sh sentinel.sh &> sentinel.log &

For the former, the example lines will be added later.

