#### **Mason not installing pylsp**
When trying to run nvim with my config in a docker container, Mason was failing to install the Python lsp. `:MasonLog` reports things are failing with: `Installation failed for Package(name=python-lsp-server) error=spawn: python3 failed with exit code 1 and signal 0.`. The issue seemed to be missing `python3.X-venv` for the installed version of Python. In my case, the docker container contained Python3.10.2, and I needed to `sudo apt install python3.10-venv`.

[Back to README](../README.md)