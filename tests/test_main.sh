#! /bin/sh
# file: examples/equality_test.sh

testChartGT() {
    # Input: chart 2.3.1 / index 2.1.0
    # Output: No error message and exit code 0
    #
    # Prepare
    chartpath="assets/andi_2.3.1.ymal"
    indexpath="assets/index.yaml"

    # Execute
    actualErrorMsg=$(bash ../main.bash "${chartpath}" "${indexpath}"  2>&1 > /dev/null )
    actualExitCode=$?

    # Verify
    expectedErrorMsg=""
    expectedExitCode=0
    assertEquals  "${expectedErrorMsg}" "${actualErrorMsg}"
    assertEquals  "${expectedExitCode}" "${actualExitCode}"
}

testChartLT_major() {
    # Input: chart 1.3.1 / index 2.1.8
    # Output: exit code 1, error related to major
    #
    # Prepare
    chartpath="assets/andi_1.3.1.ymal"
    indexpath="assets/index.yaml"

    # Execute
    actualErrorMsg=$(bash ../main.bash "${chartpath}" "${indexpath}"  2>&1 > /dev/null )
    actualExitCode=$?

    # Verify
    expectedErrorMsg="Major version on chart is older than the last published"
    expectedExitCode=1
    assertEquals  "${expectedErrorMsg}" "${actualErrorMsg}"
    assertEquals  "${expectedExitCode}" "${actualExitCode}"
}

testChartLT_minor() {
    # Input: chart 2.0.1 / index 2.1.8
    # Output: exit code 1, error related to major
    #
    # Prepare
    chartpath="assets/andi_2.0.1.ymal"
    indexpath="assets/index.yaml"

    # Execute
    actualErrorMsg=$(bash ../main.bash "${chartpath}" "${indexpath}"  2>&1 > /dev/null )
    actualExitCode=$?

    # Verify
    expectedErrorMsg="Minor version on chart is older than the last published"
    expectedExitCode=1
    assertEquals  "${expectedErrorMsg}" "${actualErrorMsg}"
    assertEquals  "${expectedExitCode}" "${actualExitCode}"
}

testChartLT_patch() {
    # Input: chart 2.1.4 / index 2.1.8
    # Output: exit code 1, error related to major
    #
    # Prepare
    chartpath="assets/andi_2.1.4.ymal"
    indexpath="assets/index.yaml"

    # Execute
    actualErrorMsg=$(bash ../main.bash "${chartpath}" "${indexpath}"  2>&1 > /dev/null )
    actualExitCode=$?

    # Verify
    expectedErrorMsg="Patch version on chart is older than the last published"
    expectedExitCode=1
    assertEquals  "${expectedErrorMsg}" "${actualErrorMsg}"
    assertEquals  "${expectedExitCode}" "${actualExitCode}"
}

testChartEq_all() {
    # Input: chart 2.1.8 / index 2.1.8
    # Output: exit code 1, error related to major
    #
    # Prepare
    chartpath="assets/andi_2.1.8.ymal"
    indexpath="assets/index.yaml"

    # Execute
    actualErrorMsg=$(bash ../main.bash "${chartpath}" "${indexpath}"  2>&1 > /dev/null )
    actualExitCode=$?

    # Verify
    expectedErrorMsg="Patch version on chart is older than the last published"
    expectedExitCode=1
    assertEquals  "${expectedErrorMsg}" "${actualErrorMsg}"
    assertEquals  "${expectedExitCode}" "${actualExitCode}"
}
# Load shUnit2.
. shunit2
