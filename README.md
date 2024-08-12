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

# emulator snapshot save and load command
all below command will be executed from .android/avd in which state emulator snapshot want to take

1). Save snapshot and copy it another location
 - baseline is path where want to save emulator snapshot in same directory `.android/avd/emulator_name/snapshots/baseline`
   ```sh
   adb emu avd snapshot save baseline
   ```
 - snapshot copied to desktop
   ``` sh
   adb emu avd snapshot pull baseline /home/manishsharma/Desktop/baseline_snapshot
   ```
 - it will list all snapshots which is saved in avd
   ```sh
   adb emu avd snapshot list
   ```
   
 - using above two command snapshot saved and copied to desktop

2). use saved sanpshot to a emulator but the condition is saved snapshot and where we want to use , that emulator configuration must be same
 - this command will load saved snapshot at `.android/avd/emulator_name/snapshots/baseline`
    ``` sh
     adb emu avd snapshot load baseline
     ```
- this command will apply svaed snapshot in emulator
   ``` sh
    adb emu avd snapshot push baseline /home/manishsharma/Desktop/baseline_snapshot
   ```

# Execute emulator using  command line 
- to run emulator from command line , just open cmd from `/Android/Sdk/emulator`and run below command`
  
  ```sh
  ./emulator -avd emulator_name -grpc 8554
  ```
  - grpc : gRPC is used for communication between applications or services. In the context of Android emulators, gRPC can be used to interact with the emulator from an external application or script
   - so we can  simply say `-grpc` specifies that the emulator should start a gRPC server.
  - Port Number `8554` : This is the network port on which the gRPC server (the emulator, in this case) listens for incoming gRPC connections. The number 8554 is an arbitrary port number that you can specify; it is not a default or special port number for gRPC itself. You can choose any available port number that is not in use by another service on your system.
   - we can simply say `8554` is the port number where the gRPC server listens for incoming connections
- to check port execute command
``` sh
 adb devices
```
and the outpot is
```sh
 List of devices attached
 emulator-5554	device
```
here -5554 is port

# Extract emulator and put it another place and then run emulator
- To extract emulator go to directory `.android/avd` and create zip of `emulator.avd` and `emulator.ini` and also before create zip just save snapshot and close emulator
- in linus to create zip execute
  ```sh
  tar -czvf emulator_name.tar.gz emulator_name.avd emulator_name.ini
  ```
- `.ini` file work as bridge to execute extracted emulator from exteranal directory
- when want to execute extracted emulator just edit your `.ini` file as :
   - i want to execute my emulator from desktop
   - extaract emulator zip file on desktop
   - here you will edit `path` and `path.rel` of  your extraxted `.ini` file and remaning will samelike :
     ```sh
        avd.ini.encoding=UTF-8
        path=/home/manishsharma/Desktop/Pixel_3_API_33.avd
        path.rel=../../Desktop/Pixel_3_API_33.avd
        target=android-33
     ```
 - now paste this `.ini` file in `.android/avd` and execute command to start emulator
 - in this case emulator will be in same state in which state you extracted your emulator
 - run below command to verify your emulator is in execution state if  everything is good
   ```sh
   ./emulator -list-avds
   ```
   this command will give emulator name
