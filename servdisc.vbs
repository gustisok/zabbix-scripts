' This code was converted to vbscript from Raymond Kuiper's powershell servdisc.vbs script @ https://github.com/q1x
'
' VB script to fetch a list of autostarted services via WMI and report back in a JSON
' formatted message that Zabbix will understand for Low Level Discovery purposes.
'
'#

'# First, fetch the list of auto started services
strComputer = "."
Set objWMIService = GetObject("winmgmts:" & "{impersonationLevel=impersonate}!\\" & strComputer & "\root\cimv2")
Set colListOfServices = objWMIService.ExecQuery ("Select * from Win32_Service where Startmode='Auto'")

'# Output the JSON header
Set objStdOut = WScript.StdOut
objStdOut.Write "{" & vbCRLF
objStdOut.Write """data"":[" & vbCRLF
objStdOut.Write vbCRLF

dim OutputLine

'# For each object in the list of services, print the output of the JSON message with the object properties that we are interessted in
For Each objService in colListOfServices
OutputLine = " { ""{#SERVICESTATE}"":""" & objService.State & """ , ""{#SERVICEDISPLAY}"":""" & objService.DisplayName & """ , ""{#SERVICENAME}"":""" & objService.Name & """ , ""{#SERVICEDESC}"":""" & objService.Description & """ },"
objStdOut.Write OutputLine & vbCRLF
Next

'# Close the JSON message
objStdOut.Write vbCRLF
objStdOut.Write " ]" & vbCRLF
objStdOut.Write "}" & vbCRLF
objStdOut.Write vbCRLF
