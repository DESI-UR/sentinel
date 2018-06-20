#!/bin/env bash

# set these values either in your bash profile or here
MAX_NUM_JOBS=200
WAIT_TIME=120s

QUEUE_DIRECTORY="queue"
RUN_DIRECTORY="run"
COMPLETED_DIRECTORY="complete"

function submit_jobs() {
    jobs_to_submit=$1
    list_files=`ls -t ${QUEUE_DIRECTORY} | tail -n ${jobs_to_submit}` 
    for file in ${list_files[@]}; do
	mv ${QUEUE_DIRECTORY}/${file} ${RUN_DIRECTORY}/.
	sed -i "s/queue/run/" ${RUN_DIRECTORY}/${file}
	sbatch ${RUN_DIRECTORY}/${file}
    done
}


function run_sentinel() {
    while true; do
	RUNNING_JOBS=`squeue -u ${USER} | wc -l || echo "failed"`
	if [ "${RUNNING_JOBS}" == "failed" ]; then
	    echo "problem with batch system..."
	fi
	NUM_RUNNING_JOBS=$(expr ${RUNNING_JOBS} - 1)
	echo "Number of running johs:     " ${NUM_RUNNING_JOBS}
	echo "Number of max jobs allowed: " ${MAX_NUM_JOBS}
	let "SUBMIT_JOBS = ${MAX_NUM_JOBS} - ${NUM_RUNNING_JOBS}"
	echo "Number of jobs to submit:   " ${SUBMIT_JOBS}
	if [ ${SUBMIT_JOBS} -gt 0 ]; then
	    submit_jobs ${SUBMIT_JOBS}
	fi
	echo "going to sleep"
	sleep ${WAIT_TIME}
    done
}

run_sentinel
