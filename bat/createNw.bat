del HIDE.exe
cd ../bin
7z a -r ../bat/HIDE.zip
cd ../bat
move HIDE.zip HIDE.nw
copy /b ..\..\..\node-webkit\nw.exe+HIDE.nw HIDE.exe
del HIDE.nw
pause