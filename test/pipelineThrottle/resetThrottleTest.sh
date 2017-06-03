# Just like approval_processor_commandMP, 
# approvalprocessorTest_commandMP adds resetThrottle command
# to lvalertTest_commandMP
# Whatever node is specified here should be present in the
# approval_processor child_config file
# the command file is where the commands are written when 
# running tests using lvalertTest
# below is an example of sending commands
approvalprocessorTest_commandMP --node=deep.chatterjee-test -f ~/COMMAND_FILE/command.txt group,CBC pipeline,gstlal resetThrottle -v
