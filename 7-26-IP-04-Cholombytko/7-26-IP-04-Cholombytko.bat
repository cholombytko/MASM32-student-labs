@echo off
ml /c /coff "7-26-IP-04-Cholombytko.asm"
ml /c /coff "7-26-IP-04-Cholombytko-module.asm"
link /subsystem:WINDOWS "7-26-IP-04-Cholombytko.obj" "7-26-IP-04-Cholombytko-module.obj"
7-26-IP-04-Cholombytko.exe