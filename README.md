# space-bwrap

Isolated workspace based on bubblewrap.

`swrap` and `swrap-lesser` are implementations written in Python.

`swrap.sh` is the deprecated implementation written in Bash.

## Usage

### swrap

```
swrap (name) [cmdline ...]
```

**swrap** bind-mounts the directories or sockets listed below:

Bind device:

- `/dev`

Bind in **read-only** to:

- `/etc`
- `/opt`
- `/sys`
- `/usr`
- `/run/dbus`
- `/run/systemd`
- `/tmp/.X11-unix`
- `$XAUTHORITY`
- `$XDG_RUNTIME_DIR/bus`
- `$XDG_RUNTIME_DIR/pulse`
- `$XDG_RUNTIME_DIR/pipewire-0`
- `$XDG_RUNTIME_DIR/$WAYLAND_DISPLAY`

Bind in **read-write** to:

- `$SPACE/home/$1` => `$HOME`
- `$SPACE/home/$1` => `$SPACE/home/$HOME`

### swrap-lesser

**swrap-lesser** allows running applications which put their sockets under `/tmp`, such as Chrome.

```
swrap-lesser (name) [cmdline ...]
```

**In additinon to swrap.**

Bind in **read-write**:

- `/tmp`
- `/data`
- `/exdata`

## Create workspace

Declare where the `$SPACE` is.

```
. -> required by $SPACE
└── home/ -> required
    ├── dev/
    │   ├── .bashrc
    │   ├── .config/
    │   └── .local/
    └── chrome/
        ├── .bashrc
        ├── .config/
        └── .local/
```

```shell
# bash
swrap dev

# VSCode
swrap dev /opt/vscode/code

# Chromium
swrap-lesser chrome chromium-browser

# New tab will be opened in an existing session.
swrap-lesser chrome chromium-browser
```
