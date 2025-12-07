# Script để force redeploy GitHub Pages
Write-Host "=== Force Redeploy GitHub Pages ===" -ForegroundColor Green
Write-Host ""

# Kiểm tra Git
try {
    $gitVersion = git --version
    Write-Host "Git: $gitVersion" -ForegroundColor Green
} catch {
    Write-Host "ERROR: Git chưa được cài đặt!" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Đang kiểm tra thay đổi..." -ForegroundColor Cyan

# Kiểm tra status
git status --short

Write-Host ""
Write-Host "Đang thêm tất cả thay đổi..." -ForegroundColor Cyan
git add .

Write-Host ""
Write-Host "Đang tạo commit với timestamp..." -ForegroundColor Cyan
$timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
git commit -m "Force redeploy - $timestamp" --allow-empty

Write-Host ""
Write-Host "Đang push lên GitHub..." -ForegroundColor Cyan
git push origin main

Write-Host ""
Write-Host "✓✓✓ Đã push thành công! ✓✓✓" -ForegroundColor Green
Write-Host ""
Write-Host "Bước tiếp theo:" -ForegroundColor Yellow
Write-Host "1. Vào repository: https://github.com/Kenfiz123/NguyenHuuThanh" -ForegroundColor Cyan
Write-Host "2. Chọn tab 'Actions' để xem workflow đang chạy" -ForegroundColor Cyan
Write-Host "3. Đợi workflow hoàn thành (có dấu tích xanh)" -ForegroundColor Cyan
Write-Host "4. Kiểm tra site tại: https://kenfiz123.github.io/NguyenHuuThanh/" -ForegroundColor Cyan
Write-Host ""
Write-Host "Nếu vẫn không thấy thay đổi:" -ForegroundColor Yellow
Write-Host "- Kiểm tra Settings > Pages > Source phải là 'GitHub Actions'" -ForegroundColor Yellow
Write-Host "- Xóa cache trình duyệt (Ctrl+Shift+R)" -ForegroundColor Yellow

