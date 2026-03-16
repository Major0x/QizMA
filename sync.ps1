# QuizMaster Sync Script
# This script pushes your published quizzes to GitHub for students

Write-Host "Checking for quizzes.json..." -ForegroundColor Cyan

if (!(Test-Path "quizzes.json")) {
    Write-Error "File 'quizzes.json' not found! Please click 'Publish for Students' in the app first."
    exit
}

Write-Host "Syncing with GitHub..." -ForegroundColor Cyan

git add quizzes.json index.html manifest.json sw.js
git commit -m "Update quizzes and app $(Get-Date -Format 'yyyy-MM-dd HH:mm')"
git push origin master

Write-Host "✅ Success! Your new quizzes are now live for all students." -ForegroundColor Green
Write-Host "Students will see the update automatically when they next open the app." -ForegroundColor Gray
