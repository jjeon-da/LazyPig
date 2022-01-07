::
::  Author T0rt3rra
::
@echo off
TITLE "Lazy Pig SNORT Automator"
echo Tool Start
DATE /T
TIME /T
echo ----------------------------------------------------------------------------------------------
echo Welcome to the Lazy Pig SNORT Automator.  Tool will close at finish or Press CTRL+C to cancel
echo -----------------------------------------------------------------------------------------------
echo.
Pause
echo.
SET /P OUTPUT="Enter path for output directory: "
CD %OUTPUT%
set HEADERS=timestamp,sig_generator,sig_id,sig_rev,msg,proto,src,srcport,dst,dstport,ethsrc,ethdst,ethlen,tcpflags,tcpseq,tcpack,tcpln,tcpwindow,ttl,tos,id,dgmlen,iplen,icmptype,icmpcode,icmpid,icmpseq
echo %HEADERS% > %OUTPUT%\SNORTalert.csv
echo.
SET /P I="Enter 1 if there is a single PCAP,  or 2 to list the directory for multiple files: "
echo.
IF %I%==2 CALL :sub       
echo Single File Selected
pause
SET /P PCAP="Enter path for PCAP file: "
echo cd c:\Snort\bin
cd c:\Snort\bin
echo snort -r %PCAP% -c c:\Snort\etc\snort.conf -l %OUTPUT% -yU
snort -r %PCAP% -c c:\Snort\etc\snort.conf -l %OUTPUT% -yU
type %OUTPUT%\alert.csv >> %OUTPUT%\SNORTalert.csv
echo deleting working files,  logs remain in designated output folder
del %OUTPUT%\alert.csv
echo exiting
Pause
exit


:sub
echo Multiple Files Selected
SET /P N="Enter path for input directory: "
echo Parsing Directory...
cd %N%
dir /B /Oe *.pcap* >> %output%\inputpcaplist.txt
echo.
for /F %%Q in (%output%\inputpcaplist.txt) do echo %N%^\%%Q >> %output%\pcaplist.txt
echo. 
echo Direcory Parsed. Files to Snort are below:
echo.
type %output%\pcaplist.txt
echo.
pause
echo.
cd c:\Snort\bin
echo snort --pcap-file=%output%\pcaplist.txt --pcap-show -c c:\Snort\etc\snort.conf -l %OUTPUT% -yU 
echo.
echo this will take some time...  tool will close on finish
pause
snort --pcap-file=%output%\pcaplist.txt --pcap-show -c c:\Snort\etc\snort.conf -l %OUTPUT% -yU 
type %OUTPUT%\alert.csv >> %OUTPUT%\SNORTalert.csv
echo deleting working files,  logs remain in designated output folder
del %OUTPUT%\alert.csv
del %output%\inputpcaplist.txt
del %output%\pcaplist.txt
echo exiting
Pause
exit