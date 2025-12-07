# Script để đẩy code lên GitHub
# Chạy script này sau khi đã cài đặt Git

Write-Host "=== Script đẩy code lên GitHub ===" -ForegroundColor Green
Write-Host ""

# Kiểm tra Git đã được cài đặt chưa
try {
    $gitVersion = git --version
    Write-Host "Git đã được cài đặt: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Git chưa được cài đặt!" -ForegroundColor Red
    Write-Host "Vui lòng cài đặt Git từ: https://git-scm.com/download/win" -ForegroundColor Yellow
    Write-Host "Sau khi cài đặt, mở PowerShell mới và chạy lại script này." -ForegroundColor Yellow
    exit 1
}

Write-Host ""
Write-Host "Bắt đầu khởi tạo Git repository..." -ForegroundColor Cyan

# Kiểm tra xem đã có .git chưa
if (Test-Path .git) {
    Write-Host "Git repository đã được khởi tạo." -ForegroundColor Yellow
} else {
    Write-Host "Khởi tạo Git repository..." -ForegroundColor Cyan
    git init
    Write-Host "✓ Đã khởi tạo Git repository" -ForegroundColor Green
}

# Thêm remote (nếu chưa có)
$remoteUrl = git remote get-url origin 2>$null
if ($LASTEXITCODE -ne 0) {
    Write-Host "Thêm remote repository..." -ForegroundColor Cyan
    git remote add origin https://github.com/Kenfiz123/NguyenHuuThanh.git
    Write-Host "✓ Đã thêm remote repository" -ForegroundColor Green
} else {
    Write-Host "Remote đã được cấu hình: $remoteUrl" -ForegroundColor Yellow
}

# Add tất cả files
Write-Host ""
Write-Host "Thêm các files vào staging area..." -ForegroundColor Cyan
git add .
Write-Host "✓ Đã thêm files" -ForegroundColor Green

# Commit
Write-Host ""
Write-Host "Tạo commit..." -ForegroundColor Cyan
git commit -m "Initial commit: Hugo AWS project"
if ($LASTEXITCODE -eq 0) {
    Write-Host "✓ Đã tạo commit" -ForegroundColor Green
} else {
    Write-Host "Có thể đã có commit rồi hoặc không có thay đổi nào." -ForegroundColor Yellow
}

# Đổi branch sang main
Write-Host ""
Write-Host "Chuyển sang branch main..." -ForegroundColor Cyan
git branch -M main 2>$null
Write-Host "✓ Đã chuyển sang branch main" -ForegroundColor Green

# Push lên GitHub
Write-Host ""
Write-Host "Đẩy code lên GitHub..." -ForegroundColor Cyan
Write-Host "Lưu ý: Bạn có thể được yêu cầu đăng nhập GitHub" -ForegroundColor Yellow
Write-Host "Sử dụng Personal Access Token thay vì mật khẩu" -ForegroundColor Yellow
Write-Host ""
git push -u origin main

if ($LASTEXITCODE -eq 0) {
    Write-Host ""
    Write-Host "✓✓✓ Đã đẩy code lên GitHub thành công! ✓✓✓" -ForegroundColor Green
    Write-Host "Xem tại: https://github.com/Kenfiz123/NguyenHuuThanh" -ForegroundColor Cyan
} else {
    Write-Host ""
    Write-Host "ERROR: Không thể đẩy code lên GitHub" -ForegroundColor Red
    Write-Host "Có thể do:" -ForegroundColor Yellow
    Write-Host "1. Chưa đăng nhập GitHub" -ForegroundColor Yellow
    Write-Host "2. Chưa có quyền truy cập repository" -ForegroundColor Yellow
    Write-Host "3. Cần sử dụng Personal Access Token" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Xem hướng dẫn trong file: HUONG_DAN_PUSH_GITHUB.md" -ForegroundColor Cyan
}

