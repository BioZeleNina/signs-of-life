---
title: "Session 1: first contact"
nav_order: 4
---

# SESSION 1 -- Crash and first contact
## *The terminal is all we have. Let us see if we remember how to use it.*

---

### MISSION BRIEFING

The beacon fired automatically when the nav array went down. Rescue
estimate: fourteen days. The ship is intact -- shields, life support,
water recycling all nominal. Power conservation protocol is in effect,
which means the 3D tactile console is offline. What you have is the
terminal, the sequencer, the sensor array, and ARIADNE-7, who has
opinions about all of this.

During the crash, the ship's sensors logged something anomalous. The
data is in your mission files. Before you can look at it properly, you
need to be able to find, open, and move files. This session is about
the terminal: directories, navigation, and the habits that will make
the next seven sessions possible.

> ARIADNE-7: "Welcome back online. I have been running diagnostics
> for the past three hours and forty-two minutes. I could summarise
> them but you would find it depressing. Let us start with something
> you can control: the file system."

---

### PRE-MISSION LECTURE -- The command line and why it matters

#### What is a terminal?

A terminal is a text-based interface to the computer's operating
system. Instead of clicking, you type commands. This feels slower at
first. It is not, once you are fluent. More importantly, it has three
properties that matter enormously for science:

**Reproducibility.** Everything you do is a command that can be
recorded, shared, and re-run exactly. A mouse click cannot be
reproduced by someone else reading your notes. A command can.

**Automation.** A sequence of commands can be applied to a hundred
files as easily as to one.

**Access to the tools.** Every analysis program in this course --
quality control, genome assembly, variant calling, expression
analysis -- is a command-line program. Graphical interfaces for these
tools, where they exist, are wrappers around the same commands you
will learn here.

The ship's 3D console is a wrapper. The terminal is the real
instrument.

#### The file system

Your computer organises files in a hierarchy of directories (folders).
The top is the **root** (`/`). Your working space inside the container
is `/work`. Everything you do in this course lives somewhere under
`/work/mission_data/`.

Think of it as the ship's filing system. You would not keep every
document in the same drawer. The structure you build now is the
infrastructure every subsequent session depends on.

**Key terms:**
- **Absolute path**: the full address from root, e.g. `/work/mission_data/logs/`
- **Relative path**: the address from where you are now, e.g. `logs/`
  if you are already inside `mission_data/`
- `.` means the current directory
- `..` means the parent directory (one level up)

#### Essential commands

| Command | What it does | Example |
|---|---|---|
| `pwd` | Print working directory | `pwd` |
| `ls` | List directory contents | `ls` |
| `ls -lh` | List with sizes and details | `ls -lh` |
| `cd path` | Change directory | `cd mission_data/` |
| `cd ..` | Move up one level | `cd ..` |
| `mkdir -p path` | Make directory (and parents) | `mkdir -p a/b/c` |
| `touch file` | Create an empty file | `touch notes.txt` |
| `cp source dest` | Copy a file | `cp file.txt copy.txt` |
| `mv source dest` | Move or rename | `mv old.txt new.txt` |
| `rm file` | Delete (permanent -- no undo) | `rm unwanted.txt` |
| `cat file` | Print file contents | `cat notes.txt` |
| `head -N file` | Print first N lines | `head -5 file.txt` |
| `tail -N file` | Print last N lines | `tail -5 file.txt` |
| `echo "text" >> file` | Append text to file | `echo "note" >> log.txt` |
| `nano file` | Open text editor | `nano notes.txt` |
| `grep pattern file` | Search file for pattern | `grep "aurora" log.txt` |
| `find . -name "*.fq"` | Find files by name | `find . -name "*.txt"` |
| `wc -l file` | Count lines | `wc -l file.txt` |
| `cmd1 \| cmd2` | Pipe output to another command | `ls \| wc -l` |
| `>>` | Append to file | `echo "note" >> log.txt` |
| `>` | Overwrite file | `echo "note" > log.txt` |

**Important:** `>>` adds to the end of an existing file. `>` replaces
the entire file. Confusing them is a common mistake. When in doubt,
use `>>`.

#### Commands in bash vs zsh

All commands in this course run inside the Docker container, which
uses bash (Linux). If you run commands in your own terminal on Mac
(which uses zsh) or Windows (PowerShell), there are minor syntax
differences. The session documents always note when commands differ
between platforms outside the container.

Inside the container, everything is bash and identical regardless of
your host operating system.

#### The mission log

You will maintain a plain-text mission log throughout the course:
`mission_data/logs/mission_log.txt`. Add to it after each session.
A good entry records: what you did, the command you ran, the output
you got, and what you concluded. This is how your work is graded for
reproducibility.

---

### TUTORIAL -- File system navigation with yeast data

In this tutorial you practice every skill in this session using the
yeast tutorial data. Commands work identically on the alien data.

All commands run inside the Docker container. Start it if you have
not done so:

**Mac (Terminal):**
```bash
cd ~/course_data/signs-of-life
docker run -it --rm \
  -v "$(pwd):/work" \
  biozelenina/signs-of-life:latest
```

**Windows (PowerShell):**
```powershell
cd $HOME\course_data\signs-of-life
docker run -it --rm `
  -v "${PWD}:/work" `
  biozelenina/signs-of-life:latest
```

Your prompt changes to `[ARIADNE-7 | work]#`. You are inside the
container.

#### Step 1 -- Orient yourself

```bash
pwd
```

Expected output: `/work`

```bash
ls -lh
```

What directories and files are already here?

#### Step 2 -- Build the mission directory structure

```bash
mkdir -p mission_data/session_01/tutorial
mkdir -p mission_data/session_01/mission
mkdir -p mission_data/logs
```

```bash
ls -l mission_data/
ls -l mission_data/session_01/
```

> ARIADNE-7: "Good. You have created a directory structure. I
> appreciate an organised file system. It suggests a scientist who
> will be able to find their data in three weeks."

#### Step 3 -- Navigate the tutorial data

```bash
cd tutorial_data/yeast
```

```bash
ls -lh
```

You should see the yeast reference genome, sequencing reads, and
other files. Read the file sizes. The `.fastq` files are the largest
-- these are the sequencing read files you will use in sessions 2--7.

#### Step 4 -- Inspect a file

```bash
head -8 scerevisiae_chrI.fasta
```

This is a FASTA file: a sequence format with a header line starting
with `>` followed by the sequence.

```bash
wc -l scerevisiae_chrI.fasta
```

How many lines? Divide by 2 (header + sequence per entry) to get
the number of sequences.

```bash
grep -c ">" scerevisiae_chrI.fasta
```

`grep -c` counts lines matching the pattern. For FASTA files,
`>` appears once per sequence. How many sequences are in this file?

#### Step 5 -- Create and edit the mission log

```bash
cd /work
touch mission_data/logs/mission_log.txt
echo "Session 01 started" >> mission_data/logs/mission_log.txt
```

```bash
cat mission_data/logs/mission_log.txt
```

Now add a longer note using `nano`:

```bash
nano mission_data/logs/mission_log.txt
```

In nano: arrow keys to move, type at the cursor. Add:
`Tutorial: yeast FASTA contains 1 chromosome, 230218 bp`

Save: hold `Ctrl`, press `O`, press `Enter`
Exit: hold `Ctrl`, press `X`

```bash
cat mission_data/logs/mission_log.txt
```

Confirm your addition is there.

#### Step 6 -- Practice copy, move, and remove

```bash
cd mission_data/session_01/tutorial
cp /work/tutorial_data/yeast/scerevisiae_chrI.fasta chrI_copy.fasta
ls -lh
```

```bash
mv chrI_copy.fasta yeast_reference.fasta
ls -lh
```

```bash
rm yeast_reference.fasta
ls -lh
```

> ARIADNE-7: "You deleted a file without hesitation. For future
> reference: `rm -i` asks for confirmation before deleting.
> Consider using it until you are comfortable with which files
> you want to keep."

#### Step 7 -- Find things and combine commands

```bash
cd /work

find tutorial_data -name "*.fastq" | wc -l
```

`find` lists files matching the pattern. `wc -l` counts the lines
(i.e. the files). How many FASTQ files are in the tutorial data?

```bash
find tutorial_data -name "*.fastq" | head -5
```

```bash
grep -r "NC_001133" tutorial_data/yeast/ | head -3
```

`grep -r` searches recursively through all files in a directory.
Which files contain the chromosome I accession number?

#### Tutorial checkpoint

```bash
echo "Session 01 tutorial complete." >> mission_data/logs/mission_log.txt
echo "Tutorial FASTQ file count: $(find tutorial_data -name '*.fastq' | wc -l)" \
  >> mission_data/logs/mission_log.txt
```

---

### MAIN MISSION -- First contact: what did the sensors find?

Apply the same skills to the alien mission data.

```bash
cd /work/mission_data/session_01/mission
```

#### Step 1 -- Download the mission files

The lore files for session 1 are in the course repository:

```bash
ls -lh /work/mission_data/session_01/mission/
```

You should see `sensor_log_aurora.txt`, `mission_brief.txt`, and
`XB7734_survey_form_template.txt`. If these are missing, they should
have been downloaded by `download_data.sh`. Check:

```bash
ls /work/mission_data/
```

#### Step 2 -- Read the mission briefing

```bash
cat mission_brief.txt
```

> ARIADNE-7: "This is the automatic survey log from the moment of
> impact onward. I have flagged what I consider the most anomalous
> readings. I want to be clear I flagged them before you arrived.
> I have been doing science this entire time."

#### Step 3 -- Investigate the aurora sensor log

```bash
cat sensor_log_aurora.txt
```

Read the full log. Then search for specific information:

```bash
grep "Hz" sensor_log_aurora.txt
```

```bash
grep "UV" sensor_log_aurora.txt
```

```bash
grep -i "anomal" sensor_log_aurora.txt
```

Note the two frequency values. You will need them for the gate
question.

> ARIADNE-7: "You will notice two frequencies forming a harmonic
> ratio. Geologically speaking, this pattern is extremely unusual.
> I am not drawing conclusions. I am noting that geology does not
> typically produce harmonic resonance. That is all."

#### Step 4 -- Complete the field survey form

Protocol XBFA-7 requires documentation of all potentially biotic
observations before sequencing is authorised.

```bash
cp XB7734_survey_form_template.txt XB7734_survey_form_completed.txt
ls -l
```

Now run the interactive survey. ARIADNE-7 will guide you through
filling in the form, teaching you `echo >>`, `nano`, and `cat`
along the way:

```bash
ariadne survey
```

After the survey:

```bash
cat XB7734_survey_form_completed.txt
```

#### Step 5 -- Update your mission log

```bash
echo "Session 01 mission: field survey completed." \
  >> /work/mission_data/logs/mission_log.txt

echo "Aurora frequencies noted from sensor log." \
  >> /work/mission_data/logs/mission_log.txt
```

---

### MISSION DEBRIEF

The sensor log records a structured frequency signature at two values
in a 3:2 harmonic ratio, correlated with the aurora event. A surface
sample shows UV absorption at 260 nm and polymer-like viscosity. You
cannot conclusively confirm life. You cannot conclusively rule it out.
Per Protocol XBFA-7, further investigation is authorised.

The sequencer comes online in session 2.

**Reproducibility check:** Open your mission log and read it as if
you were a stranger. Could you reproduce what you did from these
notes? Add anything missing before continuing.

---

### GATE QUESTION -- Session 1

```bash
ariadne submit --session 1
```

> ARIADNE-7: "What is the 3:2 frequency ratio you found in the
> sensor log? Give the two frequencies in Hz, lower value first,
> separated by a space."

*Example format:* `NNN NNN`

You can only answer this correctly if you read and searched
`sensor_log_aurora.txt` in Step 3 above.

---

### REFERENCE -- Commands used in this session

| Command | What it does |
|---|---|
| `pwd` | Show current directory |
| `ls -lh` | List contents with sizes |
| `cd path` | Move to a directory |
| `cd ..` | Move up one level |
| `mkdir -p path` | Create directory tree |
| `touch file` | Create empty file |
| `cp source dest` | Copy a file |
| `mv source dest` | Move or rename |
| `rm file` | Delete permanently |
| `cat file` | Print file contents |
| `head -N file` | Print first N lines |
| `echo "text" >> file` | Append text |
| `nano file` | Open text editor |
| `grep pattern file` | Search for pattern |
| `grep -c pattern file` | Count matching lines |
| `grep -r pattern dir` | Search recursively |
| `find . -name "*.ext"` | Find files by name |
| `wc -l` | Count lines |
| `cmd1 \| cmd2` | Pipe output between commands |
| `ariadne survey` | Complete the field survey form |
| `ariadne submit --session 1` | Submit gate answer |
| `ariadne hint --session 1` | Get a hint |
| `exit` or `Ctrl+D` | Exit the container |
