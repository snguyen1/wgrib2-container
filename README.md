WGRIB2 on Container (Debian Bulleyes)
### Note: I update the container based on: https://hub.docker.com/r/bearstudio/wgrib/
## USAGE

### Build:
`docker build -t sondngyn/wgrib2 .`

### Usage:

#### Docker-Compose CLI
Create `.env` file from `.env.dist` and change the env values to the dirs location on your computer (for windows, use `/c/abs/path/`)
`docker-compose build wgrib2`
`docker-compose up wgrib2` (change `command` in docker-compose file to your script filename before running `up`)

#### Docker CLI
##### On Linux:
`docker run -v /path/to/data:/srv/ -v /path/to/script:/opt/ sondngyn/wgrib2 /opt/script_file_name.sh`
##### On Windows: 
*Note:
Remember to put `#!bin/bash` in the beginning of your script file
Make sure your script file uses LF (Linux line break types) instead of CRLF (Windows)
`docker run -v /c/absolute/path:/srv/ -v /c/absolute/path/:/opt/ sondngyn/wgrib2 /opt/script_file_name.sh`
(watch out for back-slashes and forward-slashes)
### Example on Windows (powershell): 
`docker run -v C:\Users\myuser\mydata\:/srv/ -v C:\Users\myuser\myscript\:/opt/ sondngyn/wgrib2 /opt/myscript.sh`

## DEV:
0. Clean up: `docker container rm wgrib2 -f`
1. Build image: `docker build -t wgrib2 .`
2. Spin up container: `docker run --rm --name wgrib2 -d -it wgrib2`
3. Exec: `docker exec -it wgrib2 bash`
