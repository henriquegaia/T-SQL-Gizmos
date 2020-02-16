[console]::ForegroundColor = "white"
[console]::BackgroundColor = "blue"

git add .
git commit -m "Blah"
git pull origin master

$CONFLICTS=$(git ls-files -u | wc -l)
if ( $CONFLICTS -gt 0 ) {	
	[console]::ForegroundColor = "green"
	[console]::BackgroundColor = "black"
	echo "There is a merge conflict. Aborting ..."
	git merge --abort
	exit 1
}

git push origin master

[console]::ForegroundColor = "green"
[console]::BackgroundColor = "black"

Write-Host -NoNewLine 'Press any key to continue...';
$null = $Host.UI.RawUI.ReadKey('NoEcho,IncludeKeyDown');