# startup-companion

This is a companion app for when you start with a new computer. It will install some basic tools and applications to ease your life.

Currently, it only supports Ubuntu, but it can be easily extended to support other OSes.

It can add some aliases, run a docker image on startup, install some applications, etc.

## Usage

```bash
./run
```

It will run a companion that will first ask you for which OS you want to run some tasks.

Once the OS selected, it will ask you for which tasks you want to run.

For some tasks, it can require some dependencies, which are for most cases already included in the companion.

## Add a task

To add a task, you need to run the following command:

```bash
./build-task
```

It will help you create a new task, and then it will create a new folder in `tasks` with the name of the task. You can then implement the code required for it.

## Tasks

- Add bash shell aliases: add some aliases to your bash shell
- Add MySQL docker image: Run a MySQL docker image on startup, so that you have access to a local DB without running MySQL server.
- Add git aliases: add some git aliases, to ease your life with git
- Add startup script: add a startup script to your OS, so that you can run some commands on startup

## TODO
- [ ] Add task to install Docker
- [ ] Add tasks to startup script (like other docker images)
