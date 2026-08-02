---
title: "Session 0: setup"
nav_order: 2
---

# SESSION 0 -- Pre-departure equipment check
## *Before you leave for the survey, make sure your kit works.*

*Complete this session at home before the first in-person session.
It takes approximately 20 minutes.*

---

### MISSION BRIEFING

You have been assigned to Survey Mission XB-7734-DELTA as a junior
scientist. The mission briefing is in the
[prologue]({{ site.baseurl }}/). Read it first.

Before departure, every crew member must verify that their equipment
is functional. For this mission, your primary equipment is:

1. A Docker container running the ship's analysis suite
2. A terminal interface through which you and ARIADNE-7 communicate

ARIADNE-7 has been online for longer than anyone planned. She has had
time to prepare. What she has not had is someone to talk to.

Let us not keep her waiting.

---

### PRE-MISSION BRIEFING -- What is Docker and why do we use it?

**The problem Docker solves**

Bioinformatics tools are notoriously difficult to install. A tool that
works perfectly on one computer may fail on another because of different
operating system versions, different library versions, or different
hardware. This is one of the main reasons computational analyses are
often difficult to reproduce.

Docker solves this by packaging an entire software environment -- the
operating system, the tools, the libraries, the configuration -- into a
single **image** that runs identically on any machine that has Docker
installed.

**Key concepts**

| Term | What it means |
|---|---|
| Image | A frozen software environment, like a recipe |
| Container | A running instance of an image, like a dish made from the recipe |
| Volume mount | A connection between a folder on your machine and a folder inside the container, so files you create persist after the container exits |

In this course:
- The **image** contains all the analysis tools you will use (FastQC,
  SPAdes, samtools, salmon, ARIADNE-7, and more)
- You run a **container** from the image at the start of each session
- Your data and results live in a **volume-mounted folder** on your
  own machine, so nothing is lost when the container stops

**Why this matters for science**

A Docker image is a form of reproducibility: anyone with Docker can
run the same environment you used, and get the same results. This is
the same principle as publishing your code alongside your paper -- it
makes your work verifiable.

---

### SETUP GUIDE

#### Step 1 -- Install Docker Desktop

Follow the instructions in `docker_install_guide.md` for your
operating system (Mac or Windows). The guide covers installation,
common troubleshooting, and verifying the install.

Return here once you can run `docker run --rm hello-world` and see the
success message.

#### Step 2 -- Pull the course image

**On Mac -- open Terminal and run:**

```bash
docker pull biozelenina/signs-of-life:latest
```

**On Windows -- open PowerShell and run:**

```powershell
docker pull biozelenina/signs-of-life:latest
```

This downloads the course image. It is approximately 3 GB and may take
several minutes depending on your connection speed. You only need to do
this once.

#### Step 3 -- Create your course data folder

**On Mac:**

```bash
mkdir -p ~/course_data
```

**On Windows:**

```powershell
mkdir $HOME\course_data
```

This is the folder where all your work will live. It is mounted into
the container each time you run it, so your files persist between
sessions.

#### Step 4 -- Download the course data

Clone the course repository and run the data download script:

**On Mac:**

```bash
cd ~/course_data
git clone https://github.com/BioZeleNina/signs-of-life.git
cd signs-of-life
bash download_data.sh
```

**On Windows:**

The download script (`download_data.sh`) is a bash script. PowerShell
cannot run bash scripts natively, so you need to use **Git Bash**
for this step. Git Bash is installed automatically when you install
Git for Windows.

**Step 4a -- Install Git for Windows (if you have not already)**

Go to https://git-scm.com/download/win and download the installer.
Run it and accept all default options. This installs both `git` and
Git Bash.

**Step 4b -- Open Git Bash**

Press the Windows key, type `Git Bash`, and press Enter. A terminal
window opens with a `$` prompt. This is different from PowerShell --
it understands bash commands.

**Step 4c -- Run the following commands in Git Bash:**

```bash
cd ~/course_data
git clone https://github.com/BioZeleNina/signs-of-life.git
cd signs-of-life
bash download_data.sh
```

Note: in Git Bash, `~` refers to your home folder
(`C:\Users\YourName`), so `~/course_data` is the same folder you
created in Step 3.

**Step 4d -- Return to PowerShell for all subsequent steps**

Steps 5 onwards use `docker` commands, which work correctly in
PowerShell. Once the download is complete, you can close Git Bash and
return to PowerShell for the rest of the setup.

This downloads all mission data and tutorial data files. It may take
several minutes depending on your internet connection. A progress bar
shows the download status for each file group.

#### Step 5 -- Start the container

**On Mac:**

```bash
cd ~/course_data
docker run -it --rm -v "$(pwd)/signs-of-life:/work" \
  biozelenina/signs-of-life:latest
```

**On Windows:**

```powershell
cd $HOME\course_data
docker run -it --rm -v "${PWD}\signs-of-life:/work" `
  biozelenina/signs-of-life:latest
```

You will see a greeting from ARIADNE-7. Your prompt changes to:

```
[ARIADNE-7 | work]#
```

The container is running. You are ready.

> Note: the platform warning you may see on Apple Silicon
> (`The requested image's platform does not match...`) is expected and
> harmless. The image runs under Rosetta emulation and works correctly.

#### Step 6 -- Verify ARIADNE-7

Inside the container:

```bash
ariadne hello
```

ARIADNE-7 should introduce herself and display her current status.

If the `ariadne` command is not found, check that your prompt shows
`[ARIADNE-7 | work]#` and not `(base)` or `(aliensession)`. If it
shows one of the latter, the container is from an old image. Exit
with `exit` and pull the latest image in Step 2.

#### Step 7 -- Exit the container

When you are done, type:

```bash
exit
```

Or press `Ctrl+D`. The container stops and is removed (`--rm` flag).
Everything saved in `/work` is still in your `signs-of-life/` folder
on your own machine.

---

### MISSION DEBRIEF

You have verified your equipment. ARIADNE-7 is online. The data is
downloaded. You are ready for Session 1.

---

### TROUBLESHOOTING

**Docker Desktop will not start:**
Make sure Docker Desktop is running (look for the whale icon in your
menu bar or system tray). The container cannot start if Docker Desktop
is not running.

**`docker pull` says "access denied" or "not found":**
The image name must be exact. Check `biozelenina/signs-of-life:latest`
and try again. If the error persists, contact the course coordinator.

**`ariadne hello` says "command not found":**
Your container is from an old image that does not have ARIADNE-7.
Exit with `exit`, run `docker pull biozelenina/signs-of-life:latest`
to update, and start again from Step 5.

**The prompt shows `(base)` or `(aliensession)` instead of
`[ARIADNE-7 | work]#`:**
Same issue as above. The ARIADNE-7 prompt was added in a later image
version. Update and restart.

**ARIADNE-7's rainbow output is hard to read:**
Run this inside the container:

```bash
export ARIADNE_PLAIN=1
```

All ARIADNE-7 output will be plain white text for the rest of this
container session.

**Everything looks correct but something else is wrong:**
Open an issue on the course GitHub repository or contact the course
team. Include the exact error message you see.

---

### REFERENCE -- Docker commands for this course

| Command | What it does |
|---|---|
| `docker pull IMAGE` | Download or update the course image |
| `docker run -it --rm -v "$(pwd)/signs-of-life:/work" IMAGE` | Start a container (Mac) |
| `docker run -it --rm -v "${PWD}\signs-of-life:/work" IMAGE` | Start a container (Windows) |
| `exit` or `Ctrl+D` | Stop the container and return to your own terminal |
| `docker images` | List images you have downloaded |
| `docker system df` | Show how much disk space Docker is using |
| `docker system prune -a` | Remove unused images and containers to free space |
