WGRIB2 on Container (Debian Bulleyes)
### Note: I update the container based on: https://hub.docker.com/r/bearstudio/wgrib/
# USAGE

## Windows: 
`docker run --rm --name wgrib2 -v C:\absolute\path\to\data\dir\:/srv/ -v C:\absolute\path\to\script\dir\:/opt/ wgrib2 /opt/script_file_name.sh`
## Example on Windows (powershell): 
`docker run --rm --name wgrib2 -v C:\Users\myuser\mydata\:/srv/ -v C:\Users\myuser\myscript\:/opt/ /opt/myscript.sh`

# DEV:
0. Clean up: `docker container rm wgrib2 -f`
1. Build image: `docker build -t wgrib2 .`
2. Spin up container: `docker run --rm --name wgrib2 -d -it wgrib2`
3. Exec: `docker exec -it wgrib2 bash`
