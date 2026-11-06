# ASSIGNMENT02 — Sensor Monitoring System

The assignment combines a simulated kernel sensor with a POSIX threaded
userspace pipeline.

```mermaid
flowchart LR
    Driver[/dev/sms_sensor] --> Sensor[Sensor thread]
    Mock[Mock generator] --> Sensor
    Sensor --> Buffer[Circular buffer]
    Buffer --> Processor[Processor thread]
    Processor --> AlarmQ[Alarm queue]
    Processor --> LogQ[Log queue]
    AlarmQ --> Alert[Alert thread]
    Alert --> LogQ
    LogQ --> Logger[Logger thread]
```

Build and run on Linux:

```bash
make -C app clean host tests
make -C app test
./app/bin/sms_app_x86 --mock --duration 5
```

The mock path does not require a kernel module. Real-device execution requires
the matching guest kernel, `/dev/sms_sensor`, and reviewed module setup.

Tests cover CSV parsing, the producer, rolling averages, alarms, buffer drain,
message queues, logger flush, and rotation. They were not rerun on this Windows
machine because Linux, GCC, and Make are unavailable.

Known risks: committed backups and binaries, duplicated `LAB02` snapshot,
limited provenance metadata, and no fresh sanitizer or queue-saturation run.
