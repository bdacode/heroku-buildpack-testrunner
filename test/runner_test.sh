#!/bin/sh

. ${BUILDPACK_TEST_RUNNER_HOME}/lib/test_utils.sh

testValidBuildpackWithTests()
{
  mkdir -p ${OUTPUT_DIR}/valid_buildpack/test
  touch ${OUTPUT_DIR}/valid_buildpack/test/sample_test.sh

  capture ${BUILDPACK_TEST_RUNNER_HOME}/bin/run ${OUTPUT_DIR}/valid_buildpack
  assertContains "Running tests for buildpack '${OUTPUT_DIR}/valid_buildpack'" "$(cat ${STD_OUT})"
  assertContains "Ran 0 tests." "$(cat ${STD_OUT})"
  assertEquals "" "$(cat ${STD_ERR})"
  assertEquals "0" "${rtrn}"
}

testInvalidBuildpackDirectory()
{
  capture ${BUILDPACK_TEST_RUNNER_HOME}/bin/run ${OUTPUT_DIR}/invalid_buildpack
  assertEquals "${OUTPUT_DIR}/invalid_buildpack is not a directory" "$(cat ${STD_ERR})"
  assertEquals "1" "${rtrn}"
}


testInvalidBuildpackDoesNotContainTestDirectory()
{
  mkdir ${OUTPUT_DIR}/buildpack_without_tests

  capture ${BUILDPACK_TEST_RUNNER_HOME}/bin/run ${OUTPUT_DIR}/buildpack_without_tests
  assertEquals "Buildpack '${OUTPUT_DIR}/buildpack_without_tests' does not contain valid tests. Must contain a 'test' directory and with files matching '*_test.sh'" "$(cat ${STD_ERR})"
  assertEquals "1" "${rtrn}"
}

testInvalidBuildpackDoesNotContainTests()
{
  mkdir -p ${OUTPUT_DIR}/buildpack_without_tests/test
  touch ${OUTPUT_DIR}/buildpack_without_tests/test/non_test_file.sh

  capture ${BUILDPACK_TEST_RUNNER_HOME}/bin/run ${OUTPUT_DIR}/buildpack_without_tests
  assertEquals "Buildpack '${OUTPUT_DIR}/buildpack_without_tests' does not contain valid tests. Must contain a 'test' directory and with files matching '*_test.sh'" "$(cat ${STD_ERR})"
  assertEquals "1" "${rtrn}"
}

testValidBuildpackWithTestsAndThenInvalidBuildpackWithoutTests()
{
  mkdir -p ${OUTPUT_DIR}/valid_buildpack/test
  touch ${OUTPUT_DIR}/valid_buildpack/test/sample_test.sh

  capture ${BUILDPACK_TEST_RUNNER_HOME}/bin/run ${OUTPUT_DIR}/valid_buildpack ${OUTPUT_DIR}/invalid_buildpack
  assertContains "Running tests for buildpack '${OUTPUT_DIR}/valid_buildpack'" "$(cat ${STD_OUT})"
  assertContains "Ran 0 tests." "$(cat ${STD_OUT})"
  assertEquals "${OUTPUT_DIR}/invalid_buildpack is not a directory" "$(cat ${STD_ERR})"
  assertEquals "1" "${rtrn}"
}

testInvalidBuildpackWithoutTestsAndThenValidBuildpackWithTests()
{
  mkdir -p ${OUTPUT_DIR}/valid_buildpack/test
  touch ${OUTPUT_DIR}/valid_buildpack/test/sample_test.sh

  capture ${BUILDPACK_TEST_RUNNER_HOME}/bin/run ${OUTPUT_DIR}/invalid_buildpack ${OUTPUT_DIR}/valid_buildpack
  assertContains "Running tests for buildpack '${OUTPUT_DIR}/valid_buildpack'" "$(cat ${STD_OUT})"
  assertContains "Ran 0 tests." "$(cat ${STD_OUT})"
  assertEquals "${OUTPUT_DIR}/invalid_buildpack is not a directory" "$(cat ${STD_ERR})"
  assertEquals "1" "${rtrn}"
}

testNoArgsPrintsUsage()
{
  capture ${BUILDPACK_TEST_RUNNER_HOME}/bin/run
  assertContains "Usage" "$(cat ${STD_OUT})"
  assertEquals "" "$(cat ${STD_ERR})"
  assertEquals "1" "${rtrn}"
}

testCachingArg()
{
  mkdir -p ${OUTPUT_DIR}/valid_buildpack/test
  touch ${OUTPUT_DIR}/valid_buildpack/test/sample_test.sh

  capture ${BUILDPACK_TEST_RUNNER_HOME}/bin/run -c ${OUTPUT_DIR}/valid_buildpack
  assertContains "Running tests for buildpack '${OUTPUT_DIR}/valid_buildpack'" "$(cat ${STD_OUT})"
  assertContains "Ran 0 tests." "$(cat ${STD_OUT})"
  assertEquals "" "$(cat ${STD_ERR})"
  assertEquals "0" "${rtrn}"
}
