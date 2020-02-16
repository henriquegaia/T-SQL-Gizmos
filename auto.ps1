git add .
git commit -m "Blah"
git pull origin master

$CONFLICTS = (git ls-files -u | Measure-Object -line).Lines

[console]::ForegroundColor = "yellow"
[console]::BackgroundColor = "black"

Write-Host '==> conflicts: ' $CONFLICTS

if ( $CONFLICTS -gt 0 ) {	
	[console]::ForegroundColor = "red"
	[console]::BackgroundColor = "black"
	echo "There is a merge conflict. Aborting ..."
	git merge --abort
}else{
	git push origin master
	[console]::ForegroundColor = "green"
	[console]::BackgroundColor = "black"
}
Write-Host -NoNewLine 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');
