# Architecture

## Boot path

```mermaid
sequenceDiagram
    participant Q as QEMU vexpress-a9
    participant U as U-Boot
    participant K as Linux kernel
    participant I as BusyBox /init
    Q->>U: reset and machine model
    U->>K: zImage, DTB, bootargs
    K->>I: unpack initramfs and run rdinit
    I->>K: mount proc, sysfs, devtmpfs
```

The DTB describes hardware; it is not executable firmware. The kernel matches
drivers to DT nodes, mounts the initramfs, and runs `/init`.

## Character-driver lifecycle

```mermaid
stateDiagram-v2
    [*] --> Registered: module_init
    Registered --> Open: open
    Open --> Active: read/write/ioctl
    Active --> Open: operation completes
    Open --> Registered: release
    Registered --> [*]: module_exit cleanup
```

Initialization must unwind resources in reverse order. Userspace pointers cross
the trust boundary only through `copy_to_user` and `copy_from_user`. Shared
state needs locking. Read methods must define offset and EOF behavior.

## ioctl path

```mermaid
sequenceDiagram
    participant App as userspace app
    participant VFS as VFS
    participant Driver as unlocked_ioctl
    App->>VFS: ioctl(fd, command, argument)
    VFS->>Driver: command and userspace pointer
    Driver->>Driver: validate command and value
    Driver-->>App: 0 or negative errno
```

Shared headers define ABI numbers and fixed layouts. Unknown commands return
`-ENOTTY`; invalid values return `-EINVAL`; failed copies return `-EFAULT`.

## Sensor Monitoring System

```mermaid
flowchart TD
    Device["/dev/sms_sensor or mock source"] --> Sensor[Sensor thread]
    Sensor -->|owns produced sample| Ring[Circular buffer]
    Ring --> Processor[Processor thread]
    Processor -->|alarm message| AQ[POSIX alarm queue]
    Processor -->|sample/log message| LQ[POSIX log queue]
    AQ --> Alert[Alert thread]
    Alert --> LQ
    LQ --> Logger[Logger thread]
    Logger --> File[Rotating log]
```

The circular buffer synchronizes producer and consumer access. Queue messages
copy values, avoiding shared heap ownership. Shutdown sets the stop flag,
joins the producer, stops and drains the buffer, sends queue sentinels, joins
consumers, then closes and unlinks queues. Timed sends avoid an infinite stop
wait when a sink queue is full.

Real-time scheduling requests improve priority only when the OS permits them.
Measured latency does not establish a hard real-time guarantee.
