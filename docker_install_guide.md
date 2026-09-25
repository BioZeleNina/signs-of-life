---
title: "Docker installation guide"
nav_order: 3
parent: "Session 0: setup"
---

# Docker installation guide

This guide covers installing Docker Desktop on Mac and Windows,
verifying the installation, and pulling the course image.
Return to [session 0: setup](https://biozelenina.github.io/signs-of-life/session_00_setup)
once you have completed these steps.

---

## Space requirements

Before you begin, make sure you have enough free disk space:

| Item | Size |
|---|---|
| Docker Desktop application | ~2.1 GB |
| Course Docker image (on disk after pull) | ~5.5 GB |
| Course data files (downloaded in session 0) | ~2.4 GB |
| **Total** | **~10 GB** |

---

## Mac

### System requirements

- A Mac with Apple silicon (M-series) or Intel chip
- macOS: current version or the two previous major releases
- At least 4 GB RAM (8 GB recommended)

**Apple silicon (M1/M2/M3/M4/M5):** Rosetta 2 is recommended.
To install it, open Terminal and run:

```bash
softwareupdate --install-rosetta
```

### Install Docker Desktop

1. Go to [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
   and download the installer for your chip:
   - **Apple silicon:** Docker Desktop for Mac with Apple silicon
   - **Intel:** Docker Desktop for Mac with Intel chip

2. Double-click the downloaded `Docker.dmg` file to open it.

3. Drag the Docker icon into the **Applications** folder.

4. Open **Applications** and double-click **Docker** to launch it.

5. Docker displays the Subscription Service Agreement.
   Read the key points and click **Accept** to continue.
   Docker Desktop is free for personal use, education, and small
   businesses (fewer than 250 employees and less than $10 million
   annual revenue).

6. When prompted, choose **Use recommended settings** and enter your
   Mac password if asked. Then click **Finish**.

7. Docker Desktop starts and the whale icon appears in your menu bar.
   Wait for it to stop animating before running any `docker` commands.

**No restart is required on Mac.** However, if you were asked to
install Rosetta 2 in the step above, that takes effect immediately
without a restart.

---

## Windows

### System requirements

- Windows 10 64-bit: version 22H2 (build 19045) or later
- Windows 11 64-bit: version 23H2 (build 22631) or later
- At least 8 GB RAM
- Hardware virtualisation enabled in BIOS/UEFI

Docker Desktop uses WSL 2 (Windows Subsystem for Linux 2) by default,
which does not require administrator privileges for installation.

### Install WSL 2 (if not already installed)

Open PowerShell and run:

```powershell
wsl --install
```

Or if WSL is already installed, update it:

```powershell
wsl --update
```

**You may be prompted to restart your computer after this step.
Restart before continuing.**

### Install Docker Desktop

1. Go to [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
   and download the installer for Windows (x86_64).

2. Double-click `Docker Desktop Installer.exe` to run it.

3. When asked for installation mode, choose **Per-user (recommended)**.
   This installs Docker Desktop without needing administrator
   privileges.

4. On the Configuration page, leave **Use WSL 2 instead of Hyper-V**
   selected (it should be selected by default).

5. Follow the wizard and click **Close** when installation is complete.

6. Docker Desktop does **not** start automatically after installation.
   Search for **Docker Desktop** in the Start menu and open it.

7. Docker displays the Subscription Service Agreement.
   Read the key points and click **Accept** to continue.

8. Wait for the whale icon in the system tray to stop animating before
   running any `docker` commands.

**Windows note on permissions:** If your IT department requires an
all-users installation (administrator-level), contact them before
installing. The per-user installation works for all course purposes.

---

## Verifying the installation

Once Docker Desktop is running (whale icon steady in menu bar or
system tray), open a terminal and run:

```bash
docker run --rm hello-world
```

You should see a message that starts with:

```
Hello from Docker!
This message shows that your installation appears to be working correctly.
```

If you see this, return to
[session 0: setup](https://biozelenina.github.io/signs-of-life/session_00_setup)
and continue from Step 2.

---

## Pulling the course image

**On Mac (Terminal):**

```bash
docker pull --platform linux/amd64 biozelenina/signs-of-life:latest
```

**On Windows (PowerShell):**

```powershell
docker pull --platform linux/amd64 biozelenina/signs-of-life:latest
```

This downloads approximately 1.4 GB. You will see a series of layers
downloading and the message `Status: Downloaded newer image` when
complete.

On Apple Silicon Macs (M1/M2/M3/M4/M5) you will also see:

```
WARNING: The requested image's platform (linux/amd64) does not match
the detected host platform (linux/arm64/v8)
```

This is expected and harmless. The image runs via Rosetta 2 emulation
and works correctly.

To confirm the image downloaded successfully:

```bash
docker images biozelenina/signs-of-life
```

You should see the image listed. Depending on your version of Docker
Desktop the output may look like:

```
REPOSITORY                    TAG      IMAGE ID       CREATED        SIZE
biozelenina/signs-of-life     latest   1be205949...   ...            ...
```

or the newer Docker Desktop format:

```
IMAGE                              ID             DISK USAGE   CONTENT SIZE
biozelenina/signs-of-life:latest   1be205949...       5.5GB         1.4GB
```

Either format confirms the image is ready. The image uses approximately
5--6 GB of disk space once extracted.
ARIADNE-7 is verified in [session 0: setup](https://biozelenina.github.io/signs-of-life/session_00_setup)
once the course data folder exists.

---

## Starting a course session

This section is here for quick reference in future sessions. If you
have not yet completed [session 0: setup](https://biozelenina.github.io/signs-of-life/session_00_setup),
return there first -- it walks you through the full setup including
creating the course data folder and downloading the data.

> **Before running any docker command:** make sure Docker Desktop is
> open and the whale icon in your menu bar (Mac) or system tray
> (Windows) is steady, not animated. If Docker Desktop is not running,
> every docker command will fail with a "cannot connect" error.

Each session, navigate to your course data folder and start the
container:

**On Mac:**

> **Apple Silicon (M1/M2/M3/M4/M5):** always include
> `--platform linux/amd64`. Docker Desktop uses Rosetta 2 emulation —
> it works correctly and performance is fine for this course.

```bash
cd ~/course_data/signs-of-life
docker run --platform linux/amd64 -it --rm \
  -v "$(pwd):/work" \
  biozelenina/signs-of-life:latest
```

**On Windows:**

```powershell
cd $HOME\course_data\signs-of-life
docker run --platform linux/amd64 -it --rm `
  -v "${PWD}:/work" `
  biozelenina/signs-of-life:latest
```

Your prompt changes to `[ARIADNE-7 | work]#`. Then type:

```bash
ariadne hello
```

to confirm ARIADNE-7 is responding. To exit the container at any
time: type `exit` or press `Ctrl+D`. Everything saved in `/work`
persists on your own machine.

---

## Troubleshooting

**"failed to connect to the docker API" or "dial unix ... no such file or directory":**
Docker Desktop is not running. Open it from your Applications folder
(Mac) or Start menu (Windows), wait for the whale icon to stop
animating (about 30--60 seconds), then try again.

**Docker Desktop will not start:**
Try restarting your computer. If the problem persists, uninstall and
reinstall Docker Desktop following the steps above.

**"no matching manifest for linux/arm64/v8" (Apple Silicon):**
The course image is built for `linux/amd64` only. Always add
`--platform linux/amd64` to both `docker pull` and `docker run`:

```bash
docker pull --platform linux/amd64 biozelenina/signs-of-life:latest
docker run --platform linux/amd64 -it --rm -v "$(pwd):/work" biozelenina/signs-of-life:latest
```

Docker Desktop handles the emulation via Rosetta 2 automatically.

**"no space left on device":**
Docker's virtual disk is full. In Docker Desktop go to
Settings → Resources → Virtual disk limit and increase it.
Or remove unused images: `docker system prune -a`

**Mac: "Docker.app is damaged":**
Go to System Settings → Privacy & Security and click **Open Anyway**
next to the Docker message. See the
[official troubleshooting guide](https://docs.docker.com/desktop/troubleshoot-and-support/troubleshoot/mac-damaged-dialog/)
for details.

**Windows: WSL update failed or WSL version too old:**
Run `wsl --update` in PowerShell as administrator, then restart.

**"push access denied" or authentication errors:**
These only affect the course instructor pushing the image to Docker Hub
and are not relevant during student use.
