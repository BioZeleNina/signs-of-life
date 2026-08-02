---
title: "Docker installation guide"
nav_order: 3
parent: "Session 0: setup"
---

# Docker installation guide

This guide walks through installing Docker Desktop on Mac and Windows.
Docker is required for all sessions from session 1 onward.

---

## Before you start

Docker Desktop is free for personal use, education, and small
organisations. You will need:

- A stable internet connection (the download is 500 MB to 1 GB)
- An admin account on your computer
- On Mac: macOS 12 (Monterey) or later
- On Windows: Windows 10 version 21H2 or later, or Windows 11

---

## Installing on Mac

### Step 1 -- Check your chip

Open Terminal (Applications -- Utilities -- Terminal) and run:

```bash
uname -m
```

- `arm64` means Apple Silicon (M1/M2/M3/M4) -- download the **Apple
  Silicon** version
- `x86_64` means Intel -- download the **Intel** version

Or: Apple menu -- About This Mac -- look at the Chip or Processor line.

### Step 2 -- Download Docker Desktop

Go to: https://www.docker.com/products/docker-desktop/

Click **Download for Mac** and choose the version that matches your
chip. The file will be a `.dmg` file.

### Step 3 -- Install

1. Open the downloaded `.dmg` file
2. Drag Docker into your Applications folder
3. Open Docker from Applications
4. Accept the licence agreement
5. Enter your Mac password when prompted (Docker installs a networking
   helper that requires admin access -- this is expected)
6. Wait for the whale icon in the menu bar to become steady (not
   animated). This takes about 30--60 seconds.

### Step 4 -- Verify the installation

Open Terminal (Applications -- Utilities -- Terminal) and run:

```bash
docker --version
```

You should see something like `Docker version 27.x.x, build ...`

Then run the test container:

```bash
docker run --rm hello-world
```

You should see a message starting with `Hello from Docker!`

### Mac notes

**Apple Silicon platform warning:** when running the course image,
Docker will show:

```
WARNING: The requested image's platform (linux/amd64) does not match
the detected host platform (linux/arm64/v8)
```

This is expected and harmless. The course image runs under Rosetta 2
emulation and works correctly. You can ignore this warning.

**Disk space:** Docker stores images on your internal disk. The course
image is approximately 3 GB. Check Docker's disk usage with:

```bash
docker system df
```

To reclaim space after the course:

```bash
docker system prune -a
```

---

## Installing on Windows

### Step 1 -- Check your system

Open Task Manager (`Ctrl+Shift+Esc`) -- Performance tab -- CPU.
Check that Virtualization shows **Enabled**.

If it shows Disabled, you need to enable it in your computer's
BIOS/UEFI settings before proceeding. The exact steps depend on your
computer manufacturer -- search for "enable virtualization [your
computer brand]" for instructions.

### Step 2 -- Install WSL 2

Docker Desktop on Windows uses WSL 2 (Windows Subsystem for Linux).
Open PowerShell as Administrator (right-click the Start button --
Terminal (Admin)) and run:

```powershell
wsl --install
```

Restart your computer when prompted.

### Step 3 -- Download Docker Desktop

Go to: https://www.docker.com/products/docker-desktop/

Click **Download for Windows**. The file will be a `.exe` installer.

### Step 4 -- Install

1. Run the downloaded installer
2. Keep the default option "Use WSL 2 instead of Hyper-V" selected
3. Follow the prompts and restart if asked
4. Launch Docker Desktop from the Start menu
5. Accept the licence agreement
6. Wait for the whale icon in the system tray to become steady

### Step 5 -- Verify the installation

Open PowerShell and run:

```powershell
docker --version
```

Then:

```powershell
docker run --rm hello-world
```

You should see `Hello from Docker!`

### Windows troubleshooting

**"Hardware assisted virtualization must be enabled":** go back to
Step 1 and enable virtualization in BIOS/UEFI.

**"WSL distro terminated abruptly":** open PowerShell as
Administrator and run `wsl --shutdown`, wait a few seconds, then
restart Docker Desktop.

**Windows Defender or antivirus blocking Docker:** add Docker Desktop
to your antivirus exclusions. This is common with some corporate
security software.

---

## Verifying the course image

After installing Docker Desktop, pull the course image:

**On Mac (Terminal):**

```bash
docker pull biozelenina/signs-of-life:latest
```

**On Windows (PowerShell):**

```powershell
docker pull biozelenina/signs-of-life:latest
```

This downloads approximately 3 GB. Then verify ARIADNE-7 is working:

**On Mac:**

```bash
docker run --rm biozelenina/signs-of-life:latest ariadne hello
```

**On Windows:**

```powershell
docker run --rm biozelenina/signs-of-life:latest ariadne hello
```

You should see a rainbow-coloured introduction from ARIADNE-7.

If the `ariadne` command is not found, the image may be outdated.
Pull again: `docker pull biozelenina/signs-of-life:latest`

---

## Starting a course session

Each session, you mount your course data folder into the container.

**On Mac:**

```bash
cd ~/course_data/signs-of-life
docker run -it --rm -v "$(pwd):/work" biozelenina/signs-of-life:latest
```

**On Windows:**

```powershell
cd $HOME\course_data\signs-of-life
docker run -it --rm -v "${PWD}:/work" biozelenina/signs-of-life:latest
```

Your prompt changes to `[ARIADNE-7 | work]#` and you are ready.

To exit the container at any time: type `exit` or press `Ctrl+D`.
Everything you saved in `/work` persists on your own machine.

---

## Docker commands quick reference

| Command | What it does |
|---|---|
| `docker pull IMAGE` | Download or update an image |
| `docker run -it --rm -v "$(pwd):/work" IMAGE` | Start interactive container (Mac) |
| `docker run -it --rm -v "${PWD}:/work" IMAGE` | Start interactive container (Windows) |
| `docker images` | List downloaded images |
| `docker ps` | List running containers |
| `docker system df` | Show disk usage |
| `docker system prune -a` | Remove unused images and containers |
| `exit` or `Ctrl+D` | Stop and remove the current container |
