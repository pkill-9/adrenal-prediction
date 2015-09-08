#!  /bin/bash
#
#PBS -q serial
#PBS -l nodes=1:ppn=8
#PBS -l walltime=01:30:00
#PBS -m abe
#PBS -M m.signorini@student.unimelb.edu.au
#
# Search for a set of keywords in a large file using multiple nodes of
# a HPC cluster. The output is to be a summary of each keyword, and the
# number of times it occurrs in the input.
#
# The solution taken is to break up the file being searched into many
# smaller chunks of a few thousand lines, divide them out to nodes for
# searching, and then merge the output from searching the smaller chunks.

. ${PBS_O_WORKDIR}/const.sh

cd ${TASK_PWD}

BATCH_INDEX=0
TOTAL_INPUT_FILES=`ls ${INPUT_DIR} | wc -l`

DEBUG ()
{
    cat - >&2
}

debug_print ()
{
    echo -e "`date --rfc-2822`: $@" | DEBUG
}

init ()
{
    NUMNODES=0;

    debug_print "Using nodes:"
    cat ${PBS_NODEFILE} | DEBUG

    if [ -e ${NODES_DIR} ]
    then
        yes | rm -rf ${NODES_DIR}
    fi

    if [ ! -e ${OUTPUT_DIR} ]
    then
        mkdir ${OUTPUT_DIR}
    else
        yes | rm ${OUTPUT_DIR}/*
    fi

    mkdir ${NODES_DIR}

    # create files to indicate each node that is available for running a task.
    for AVAILABLE_NODE in `cat ${PBS_NODEFILE}`
    do
        NODE_FILE=`mktemp --tmpdir=${NODES_DIR} XXXXXX`
        echo ${AVAILABLE_NODE} > ${NODE_FILE}
        debug_print "${AVAILABLE_NODE} > ${NODE_FILE}"
        NUMNODES=$((${NUMNODES}+1))
    done

    export NUMNODES;
}

# Select a free node, or spinlock until one becomes free, then store the node name in the NODE
# variable.
get_node ()
{
    debug_print "nodes directory listing:"
    ls ${NODES_DIR} | DEBUG

    # spinlock until there is at least one node available.
    while [ `ls -1 ${NODES_DIR} 2>/dev/null | wc -l` -eq 0 ]
    do
        sleep 1;
    done

    # wait to make sure that the exiting task script has put the node's
    # hostname in the marker file. This aims to avoid a race condition.
    sleep 1

    # choose the first free node and mark it as used by deleting its corresponding marker file.
    NODE_FILE=`ls -1 ${NODES_DIR} 2>/dev/null | head -1`;
    export NODE=`cat ${NODES_DIR}/${NODE_FILE}`
    debug_print "Found available node \"${NODE}\""
    debug_print "Removing marker file \"${NODES_DIR}/${NODE_FILE}\""
    rm -f ${NODES_DIR}/${NODE_FILE};
}

# run a job on a node selected by get_node by starting an SSH process in the background.
do_work ()
{
    debug_print "Starting job \"${PWD}/task.sh\" on node \"${NODE}\"\n"
    ssh ${NODE} "${PWD}/task.sh ${BATCH_INDEX}" &
    BATCH_INDEX=$((${BATCH_INDEX} + ${SAMPLES_PER_RUN}))
}

wait_for_nodes_to_exit ()
{
    COUNT=0;

    # are there any nodes still running? we will know if there are, because they won't have replaced
    # the marker file that indicates when a node is available again.
    while [ `ls -1 ${NODES_DIR} 2>/dev/null | wc -l` -lt ${NUMNODES} ]
    do
        COUNT=$((${COUNT} + 1));

        if [ ${COUNT} -gt ${TIMEOUT_MINS} ]
        then
            debug_print "Timed out waiting for workers to complete."
            return;
        fi

        sleep 1;
    done

    yes | rm -rf ${NODES_DIR}
}

#######################################
#
#   Main program.
#

init

START_TIME=`date +%s`

while [ ${BATCH_INDEX} -le ${TOTAL_INPUT_FILES} ]
do
    get_node
    do_work
done

wait_for_nodes_to_exit

debug_print "All search batches done. Merging results..."
cat ${FRAGMENTS_DIR}/* | ./bin/aggregate 2>/dev/null
debug_print "Merging done."

END_TIME=`date +%s`

echo -e "Total time (wall time): $((${END_TIME} - ${START_TIME})) seconds"

debug_print "All tasks finished. Exiting now."

# vim: ft=sh ts=4 sw=4 et
