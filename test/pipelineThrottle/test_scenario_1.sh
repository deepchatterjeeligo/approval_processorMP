#!/bin/bash

###############################################################################
# THIS SCRIPT SIMULATES POSSIBLE SCENARIOS FOR approval_processor
# THE VERSION OF approval_processor TESTED IS THE FOLLOWING BRANCH
# https://github.com/deepchatterjeeligo/approval_processorMP/tree/testingPipelineThrottle
# IT USES AND ASSUMES THE PRESENCE OF lvalertTest AND lvalertMP
# FIND THESE AT https://github.com/reedessick/lvalertTest
#   AND         https://github.com/reedessick/lvalertMP
# $PATH AND $PYTHONPATH SHOULD CONTAIN EXECUTABLES FROM ABOVE THREE REPOS

#######################BEFORE RUNNING SCRIPT###################################
# CREATE A LOCAL DIRECTORY TO BE USED BY FakeDb (CHANGE AS APPROPRIATE)
# ENSURE PRESENCE OF lvalert.out FILE
# mkdir -p /home/deep/FAKE_DB/; touch /home/deep/FAKE_DB/lvalert.out   
# CREATE A TEMPORARY OUTPUT DIRECTORY
# mkdir -p /home/deep/OUT_DIR
# CREATE A COMMAND FILE (TO WRITE COMMANDS USING approvalprocessorMP_commands)
# mkdir -p /home/deep/COMMAND_FILE; touch /home/deep/COMMAND_FILE/command.txt

# LAUNCH THE LISTENER TO MONITOR THE DIRECTORY
# lvalertTest_listenMP -f /home/deep/FAKE_DB/ -c [/home/deep/github_forked/approval_processorMP]/etc/lvalert_listenMP-approval_processorMP.ini -C /home/deep/COMMAND_FILE/command.txt -v
# PATH [...] POINTS TO LOCATION OF approval_processorMP
###############################################################################

echo "### A TOTAL 6 gstlal AND SOME USER DEFINED NUMBER OF cwb WILL BE CREATED"
echo "### ALL 6 gstlal EVENTS SHOULD GET EM_THROTTLED AT THE END OF THE RUN"
echo "### THE cwb EVENT(S) MAY NOT BE LABELLED EM_THROTTLED"
echo -e "\n\n\n### STARTING TESTING SCENARIOS ###"
echo "### CREATING ONE FAKE gstlal EVENT TO ENSURE THINGS ARE RUNNING FINE"
echo "### HIT ENTER TO CONTINUE..."
read temp
echo "RUNNING simulate.py -N 1 -r 1 -g /home/deep/FAKE_DB/ -i "H1,L1" -o /home/deep/OUT_DIR/ -s /home/deep/github_forked/lvalertTest/etc/gstlal.ini"
simulate.py -N 1 -r 1 -g /home/deep/FAKE_DB/ -i "H1,L1" -o /home/deep/OUT_DIR/ -s /home/deep/github_forked/lvalertTest/etc/gstlal.ini -v
echo -e "\n\n\n"
echo -e "### DONE\nCHECK approval_processor LOG FILE\nSHOULD BE NO THROTTLING LABEL"
echo "### CREATING 4 FAKE gstlal EVENTS IN 4 SECONDS, SO THAT PIPELINE IS THROTTLED"
echo "### HIT ENTER TO CONTINUE"
read temp
echo "RUNNING simulate.py -N 4 -r 1 -g /home/deep/FAKE_DB/ -i "H1,L1" -o /home/deep/OUT_DIR/ -s /home/deep/github_forked/lvalertTest/etc/gstlal.ini -v"
simulate.py -N 4 -r 1 -g /home/deep/FAKE_DB/ -i "H1,L1" -o /home/deep/OUT_DIR/ -s /home/deep/github_forked/lvalertTest/etc/gstlal.ini -v
echo -e "\n\n\n### DONE\nALL 4 AND **ALSO** THE FIRST ONE SHOULD BE EM_THROTTLED"
echo "### WAITING 10 SECONDS"
sleep 10




echo -e "\n\n\n### ENTER NUMBER OF cwb EVENTS YOU WANTED TO CREATE (> 0)"
echo "### THIS PIPELINE MAY NOT BE EM_THROTTLED IF YOU ENTER A LOW VALUE ~ 1"
read NUM_EV
echo "### CREATING $NUM_EV FAKE cwb EVENTS"
echo "### HIT ENTER TO CONTINUE"
read temp
echo "RUNNING simulate.py -N $NUM_EV -r 10 -g /home/deep/FAKE_DB/ -i "H1,L1" -o /home/deep/OUT_DIR/ -s /home/deep/github_forked/lvalertTest/etc/cwb.ini -v"
simulate.py -N $NUM_EV -r 10 -g /home/deep/FAKE_DB/ -i "H1,L1" -o /home/deep/OUT_DIR/ -s /home/deep/github_forked/lvalertTest/etc/cwb.ini -v
echo -e "\n\n\n### DONE"
echo "### WAITING 10 SECONDS"
sleep 10



echo -e "\n\n\n### CREATING ONE SINGLE IFO H1 EVENT\n### SHOULD FAIL ifosCheck, BUT LABELLED AS THROTTLED"
echo "### HIT ENTER TO CONTINUE"
read temp
echo "RUNNING simulate.py -N 1 -g /home/deep/FAKE_DB/ -i "H1" -o /home/deep/OUT_DIR/ -s /home/deep/github_forked/lvalertTest/etc/gstlal.ini -v"
simulate.py -N 1 -g /home/deep/FAKE_DB/ -i "H1" -o /home/deep/OUT_DIR/ -s /home/deep/github_forked/lvalertTest/etc/gstlal.ini -v

echo -e "\n\n\n### DONE ..."
echo "### PRINTING QUEUE to $HOME/test.txt"
echo -n > $HOME/test.txt
approvalprocessorTest_commandMP --node=deep.chatterjee-test -f /home/deep/COMMAND_FILE/command.txt printQueue filename,$HOME/test.txt
