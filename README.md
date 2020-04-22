# mikenye/digikam

Docker container for [digiKam](https://www.digikam.org).

The GUI of the application is accessed through a modern web browser (no installation or configuration needed on client side) or via any VNC client.

---

[![digiKam Logo](https://www.digikam.org/img/digikam_oxygen.svg)](https://www.digikam.org)[![digiKam](https://dummyimage.com/400x150/ffffff/575757&text=digiKam)](https://www.digikam.org)

Professional Photo Management with the Power of Open Source.

---

This container is based on the absolutely fantastic [jlesage/baseimage-gui](https://hub.docker.com/r/jlesage/baseimage-gui). All the hard work has been done by them, and I shamelessly copied their README.md too. I've cut the README.md down quite a bit, for advanced usage I suggest you check out the [README](https://github.com/jlesage/docker-handbrake/blob/master/README.md) from [jlesage/baseimage-gui](https://hub.docker.com/r/jlesage/baseimage-gui).

---

## Quick Start

**NOTE**: The Docker command provided in this quick start is given as an example
and parameters should be adjusted to your need.

Launch the digiKam docker container with the following command:

```shell
docker run -d \
    --name=digikam \
    -p 5800:5800 \
    -v /path/to/config:/config:rw \
    -v /path/to/pictures:/pictures:rw \
    -e USER_ID=$(id -u) \
    -e GROUP_ID=$(id -g) \
    mikenye/digikam
```

Where:

* `/path/to/config`: This is where the application stores its configuration, database and any files needing persistency.
* `/path/to/pictures`: This location contains picture files for digiKam to operate on. You can optionally set this to `:ro` (instead of `:rw`) if you prefer digiKam to operate read-only on your photos.

In the above command, the `USER_ID` and `GROUP_ID` variables will be set to the current user's UID & GID.

Browse to `http://your-host-ip:5800` to access the digiKam GUI. Your pictures will be located under `/pictures`.

## Environment Variables

To customize some properties of the container, the following environment
variables can be passed via the `-e` parameter (one for each variable).  Value
of this parameter has the format `<VARIABLE_NAME>=<VALUE>`.

| Variable       | Description                                  | Default |
|----------------|----------------------------------------------|---------|
|`USER_ID`| ID of the user the application runs as.  See [User/Group IDs](#usergroup-ids) to better understand when this should be set. | `1000` |
|`GROUP_ID`| ID of the group the application runs as.  See [User/Group IDs](#usergroup-ids) to better understand when this should be set. | `1000` |
|`TZ`| [TimeZone] of the container.  Timezone can also be set by mapping `/etc/localtime` between the host and the container. | `Etc/UTC` |
|`KEEP_APP_RUNNING`| When set to `1`, the application will be automatically restarted if it crashes or if user quits it. | `0` |
|`APP_NICENESS`| Priority at which the application should run.  A niceness value of -20 is the highest priority and 19 is the lowest priority.  By default, niceness is not set, meaning that the default niceness of 0 is used.  **NOTE**: A negative niceness (priority increase) requires additional permissions.  In this case, the container should be run with the docker option `--cap-add=SYS_NICE`. | (unset) |
|`DISPLAY_WIDTH`| Width (in pixels) of the application's window. | `1280` |
|`DISPLAY_HEIGHT`| Height (in pixels) of the application's window. | `768` |
|`VNC_PASSWORD`| Password needed to connect to the application's GUI.  See the [VNC Password](#vnc-password) section for more details. | (unset) |

## Data Volumes

The following table describes data volumes used by the container.  The mappings
are set via the `-v` parameter.  Each mapping is specified with the following
format: `<HOST_DIR>:<CONTAINER_DIR>[:PERMISSIONS]`.

| Container path  | Permissions | Description |
|-----------------|-------------|-------------|
|`/config`| rw | This is where the application stores its configuration, DB and any files needing persistency. |
|`/pictures`| ro/rw | This location contains files from your host that need to be accessible by the application. Should be `:rw` if you want digiKam to be able to write/modify/re-name your files.|

## Ports

Here is the list of ports used by the container.  They can be mapped to the host
via the `-p` parameter (one per port mapping).  Each mapping is defined in the
following format: `<HOST_PORT>:<CONTAINER_PORT>`.  The port number inside the
container cannot be changed, but you are free to use any port on the host side.

| Port | Mapping to host | Description |
|------|-----------------|-------------|
| 5800 | Mandatory | Port used to access the application's GUI via the web interface. |
| 5900 | Optional | Port used to access the application's GUI via the VNC protocol.  Optional if no VNC client is used. |

## Changing Parameters of a Running Container

As seen, environment variables, volume mappings and port mappings are specified
while creating the container.

The following steps describe the method used to add, remove or update
parameter(s) of an existing container.  The generic idea is to destroy and
re-create the container:

  1. Stop the container (if it is running):
```shell
docker stop digikam
```
  2. Remove the container:
```shell
docker rm digikam
```
  3. Create/start the container using the `docker run` command, by adjusting
     parameters as needed.

**NOTE**: Since all application's data is saved under the `/config` container
folder, destroying and re-creating a container is not a problem: nothing is lost
and the application comes back with the same state (as long as the mapping of
the `/config` folder remains the same).

## Docker Image Update

If the system on which the container runs doesn't provide a way to easily update
the Docker image, the following steps can be followed:

  1. Fetch the latest image:
```shell
docker pull mikenye/digikam
```
  2. Stop the container:
```shell
docker stop digikam
```
  3. Remove the container:
```shell
docker rm digikam
```
  4. Start the container using the `docker run` command.

## User/Group IDs

When using data volumes (`-v` flags), permissions issues can occur between the
host and the container.  For example, the user within the container may not
exists on the host.  This could prevent the host from properly accessing files
and folders on the shared volume.

To avoid any problem, you can specify the user the application should run as.

This is done by passing the user ID and group ID to the container via the
`USER_ID` and `GROUP_ID` environment variables.

To find the right IDs to use, issue the following command on the host, with the
user owning the data volume on the host:

```shell
id <username>
```

Which gives an output like this one:

```text
uid=1000(myuser) gid=1000(myuser) groups=1000(myuser),4(adm),24(cdrom),27(sudo),46(plugdev),113(lpadmin)
```

The value of `uid` (user ID) and `gid` (group ID) are the ones that you should
be given the container.

## Accessing the GUI

Assuming that container's ports are mapped to the same host's ports, the
graphical interface of the application can be accessed via:

* A web browser:
  
```text
http://<HOST IP ADDR>:5800
```

* Any VNC client:

```text
<HOST IP ADDR>:5900
```

## Security

By default, access to the application's GUI is done over an unencrypted
connection (HTTP or VNC).

Secure connection can be enabled via the `SECURE_CONNECTION` environment
variable.  See the [Environment Variables](#environment-variables) section for
more details on how to set an environment variable.

When enabled, application's GUI is performed over an HTTPs connection when
accessed with a browser.  All HTTP accesses are automatically redirected to
HTTPs.

When using a VNC client, the VNC connection is performed over SSL.  Note that
few VNC clients support this method.  [SSVNC] is one of them.

[SSVNC]: http://www.karlrunge.com/x11vnc/ssvnc.html

## Certificates

Here are the certificate files needed by the container.  By default, when they
are missing, self-signed certificates are generated and used.  All files have
PEM encoded, x509 certificates.

| Container Path                  | Purpose                    | Content |
|---------------------------------|----------------------------|---------|
|`/config/certs/vnc-server.pem`   |VNC connection encryption.  |VNC server's private key and certificate, bundled with any root and intermediate certificates.|
|`/config/certs/web-privkey.pem`  |HTTPs connection encryption.|Web server's private key.|
|`/config/certs/web-fullchain.pem`|HTTPs connection encryption.|Web server's certificate, bundled with any root and intermediate certificates.|

**NOTE**: To prevent any certificate validity warnings/errors from the browser
or VNC client, make sure to supply your own valid certificates.

**NOTE**: Certificate files are monitored and relevant daemons are automatically
restarted when changes are detected.

## VNC Password

To restrict access to your application, a password can be specified.  This can
be done via two methods:

* By using the `VNC_PASSWORD` environment variable.
* By creating a `.vncpass_clear` file at the root of the `/config` volume.
  This file should contains the password in clear-text.  During the container
  startup, content of the file is obfuscated and moved to `.vncpass`.

The level of security provided by the VNC password depends on two things:

* The type of communication channel (encrypted/unencrypted).
* How secure access to the host is.

When using a VNC password, it is highly desirable to enable the secure
connection to prevent sending the password in clear over an unencrypted channel.

**ATTENTION**: Password is limited to 8 characters.  This limitation comes from
the Remote Framebuffer Protocol [RFC](https://tools.ietf.org/html/rfc6143) (see
section [7.2.2](https://tools.ietf.org/html/rfc6143#section-7.2.2)).  Any
characters beyhond the limit are ignored.

## Shell Access

To get shell access to a the running container, execute the following command:

```shell
docker exec -ti digikam bash
```

## Support or Contact

Having troubles with the container or have questions?  Please [create a new issue](https://github.com/mikenye/docker-digikam/issues).
