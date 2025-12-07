# Hướng dẫn đẩy code lên GitHub

## Bước 1: Cài đặt Git (nếu chưa có)

Tải và cài đặt Git từ: https://git-scm.com/download/win

Sau khi cài đặt, mở PowerShell hoặc Command Prompt mới.

## Bước 2: Khởi tạo Git repository

Mở PowerShell/CMD tại thư mục project và chạy các lệnh sau:

```bash
# Khởi tạo git repository
git init

# Thêm remote repository
git remote add origin https://github.com/Kenfiz123/NguyenHuuThanh.git

# Thêm tất cả files
git add .

# Commit
git commit -m "Initial commit"

# Đẩy lên GitHub
git branch -M main
git push -u origin main
```

## Nếu đã có Git trong PATH:

Chạy các lệnh sau trong PowerShell (với quyền admin nếu cần):

```powershell
cd "C:\Users\kenfi\Downloads\hugo_aws-main\hugo_aws-main"
git init
git remote add origin https://github.com/Kenfiz123/NguyenHuuThanh.git
git add .
git commit -m "Initial commit"
git branch -M main
git push -u origin main
```

**Lưu ý:** Nếu được yêu cầu đăng nhập, bạn cần:
- Sử dụng Personal Access Token thay vì mật khẩu GitHub
- Hoặc sử dụng GitHub Desktop để dễ dàng hơn

## Cách khác: Sử dụng GitHub Desktop

1. Tải GitHub Desktop: https://desktop.github.com/
2. Mở GitHub Desktop
3. File → Add Local Repository
4. Chọn thư mục project
5. Publish repository lên GitHub

