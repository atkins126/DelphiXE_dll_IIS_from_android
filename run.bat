psexec \\main C:\Windows\System32\inetsrv\appcmd stop site /site.name:merch

psexec \\main C:\Windows\System32\inetsrv\appcmd stop apppool /apppool.name:merch



copy C:\Andy\AndroidSOAP\Win64\Debug\merch.dll \\main\merch
pause

psexec \\main C:\Windows\System32\inetsrv\appcmd start site /site.name:merch

psexec \\main C:\Windows\System32\inetsrv\appcmd start apppool /apppool.name:merch
