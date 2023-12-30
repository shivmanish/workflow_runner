# workflow_runner
test self hosted runner for jaxl call recoerding repo
link : https://github.com/shivmanish/workflow_runner/settings/actions/runners/new
# Download and configure runner
1). Go to your repo or org in which you want to run your actions on github
2). Open setting tab
3). In setting tab go to action option
4). In action open runner option
5). If any runner is available then run by ./run.sh form directory where runner configured
6). If any runner is not available then add new runner
To add new runner , on top an option add new runner
Open above option
Run all commands which is given below in above tab

# YAML file format
Must need to add below line in yaml file under run on option
…………
……..
…
 runs-on: 
      - self-hosted
      - label-1
…..
…….
…………

‘Label-1’ is the label name of created runner

