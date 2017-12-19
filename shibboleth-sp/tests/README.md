# tests
The tests are based on values defined in the [**scripts/set_vars.sh**](../scripts/set_vars.sh) file.<br>
This means changing the values the later should not break the tests.<br><br>
There is one exception though: the dynamic groups, which are not easy to test automatically.<br>
Any modification to those groups will probably make the tests fails and you will have to modify them for the new scenario.
### container_tests.sh
Testing of the container based on [shunit2](https://github.com/kward/shunit2) framework.
### docker_compose.yml
The compose file used to run the image tests.