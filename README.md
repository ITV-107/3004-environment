# 3004-environment
The Mininet environment for running the dashjs experiment for COMP3004


## Install instructions
1. `@root$ cd 3004-environment`
2. `@root$ chmod +x install.sh`
3. `@root$ sudo ./install.sh`
4. `@root$ ./make_dash.sh`
5. `@root$ sudo ./replace_dash.sh`

## Running experiment
Make sure that https://github.com/ITV-107/3004-controller is running in another VM
1. `@root$ sudo ./run.sh <###.###.###.###>` (ip of controller VM)
2. `mininet> xterm h1 h2 s3`
3. `@s3# ./add_qdisc s3-eth2 <####kbit>`
4. `@h1# iperf -c 10.0.0.2` (wait for it to finish)
5. `@h2# ./run_ff.sh`
6. Type "http://10.0.0.1/out/bbb1.mp4" into top bar and click "Load"
7. Wait for video to finish, record results.
8. `@s3# ./del_qdisc s3-eth2`
9. `mininet> exit`

