git add .
git commit -m "Blah"
git pull origin master
git push origin master

[console]::ForegroundColor = "green"
[console]::BackgroundColor = "black"

Write-Host -NoNewLine 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');