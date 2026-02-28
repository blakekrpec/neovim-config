`winget isntall LLVM.LLVM`

Then reboot PC. 

May need to add LLVM to PATH. 

Press `Win + S` search for "Environment Veriables", click "Edit the system environment variables". In the window that opens, click Environment Variables at the bottom. Scroll to `PATH` env var, and click "Edit", then "New". Add LLVM, usually at `C:\Program Files\LLVM\bin`. Won't take effect in currently open terminals. 
