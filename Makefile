##
# Chart Checker
#
# @file
# @version 0.1

lint:
	@echo "Starting static code analisys"
	shellcheck main.bash

test:
	@echo "Starting testing"
	cd tests ; bash test_main.sh

# end
