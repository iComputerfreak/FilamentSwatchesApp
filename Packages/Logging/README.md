# Logging

This package provides a simple logging API that can be used to abstract the actual logging system (e.g., Unified Logging / OSLog).

The package provides a default implementation of the provided `Logger` protocol called `ConsoleLogger` that logs messages to the console using `os_log`.
