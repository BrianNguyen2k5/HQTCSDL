# Quy Ước Viết Code (Coding Convention)

## Mục Lục
1. [Quy tắc đặt tên](#1-quy-tắc-đặt-tên)
2. [Cấu trúc code](#2-cấu-trúc-code)
3. [Quy tắc comment](#3-quy-tắc-comment)
4. [Quy tắc theo từng layer](#4-quy-tắc-theo-từng-layer)
5. [SQL và Stored Procedure](#5-sql-và-stored-procedure)
6. [Xử lý lỗi](#6-xử-lý-lỗi)
7. [Git workflow](#7-git-workflow)

---

## 1. Quy Tắc Đặt Tên

### 1.1. Tổng quan

| Loại | Quy tắc | Ví dụ |
|------|---------|-------|
| Namespace | PascalCase | `VietSport.DAL` |
| Class | PascalCase | `SanBongDTO`, `KhachHangBLL` |
| Interface | I + PascalCase | `ISanBongRepository` |
| Method | PascalCase | `GetAllSanBong()`, `ThemKhachHang()` |
| Property | PascalCase | `MaSanBong`, `TenKhachHang` |
| Parameter | camelCase | `maSanBong`, `tenKhachHang` |
| Local variable | camelCase | `danhSachSan`, `tongTien` |
| Private field | _camelCase | `_connectionString`, `_sanBongDAL` |
| Constant | UPPER_SNAKE_CASE | `MAX_SLOT_PER_DAY`, `DEFAULT_PRICE` |
| Enum | PascalCase | `TrangThaiDatSan.DaDat` |

### 1.2. Quy tắc đặt tên file

```
# DTO
SanBongDTO.cs
KhachHangDTO.cs

# DAL
SanBongDAL.cs
KhachHangDAL.cs

# BLL
SanBongBLL.cs
KhachHangBLL.cs
```

### 1.3. Quy tắc đặt tên tiếng Việt

- **KHÔNG** sử dụng dấu tiếng Việt trong code
- **ĐƯỢC PHÉP** viết tắt hoặc bỏ dấu

```csharp
// ✅ Đúng
public string TenKhachHang { get; set; }
public string DiaChi { get; set; }
public decimal TongTien { get; set; }

// ❌ Sai
public string Tên_Khách_Hàng { get; set; }
public string customerName { get; set; }  // Không nhất quán
```

---

## 2. Cấu Trúc Code

### 2.1. Thứ tự trong class

```csharp
public class SanBongBLL
{
    // 1. Constants
    private const int MAX_HOURS = 3;

    // 2. Private fields
    private readonly SanBongDAL _sanBongDAL;
    private readonly string _connectionString;

    // 3. Constructors
    public SanBongBLL()
    {
        _sanBongDAL = new SanBongDAL();
    }

    // 4. Public properties
    public int SoLuongSan { get; private set; }

    // 5. Public methods
    public List<SanBongDTO> GetAll()
    {
        // ...
    }

    // 6. Private methods
    private bool ValidateSanBong(SanBongDTO sanBong)
    {
        // ...
    }
}
```

### 2.2. Quy tắc format

```csharp
// Mỗi dòng không quá 120 ký tự
// Sử dụng 4 spaces cho indentation (không dùng tab)

// ✅ Đúng - Xuống dòng khi quá dài
public List<DatSanDTO> TimKiemDatSan(
    DateTime tuNgay,
    DateTime denNgay,
    int maSanBong,
    TrangThaiDatSan trangThai)
{
    // ...
}

// Dấu ngoặc nhọn luôn xuống dòng mới
if (condition)
{
    // code
}
else
{
    // code
}
```

### 2.3. Using statements

```csharp
// Sắp xếp theo thứ tự:
// 1. System namespaces
// 2. Third-party namespaces  
// 3. Project namespaces

using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;

using VietSport.DTO;
using VietSport.DAL;
```

---

## 3. Quy Tắc Comment

### 3.1. XML Documentation cho public members

```csharp
/// <summary>
/// Lấy danh sách tất cả sân bóng đang hoạt động
/// </summary>
/// <returns>Danh sách SanBongDTO</returns>
public List<SanBongDTO> GetAllSanBong()
{
    // ...
}

/// <summary>
/// Thêm mới một sân bóng vào hệ thống
/// </summary>
/// <param name="sanBong">Thông tin sân bóng cần thêm</param>
/// <returns>True nếu thêm thành công, False nếu thất bại</returns>
/// <exception cref="ArgumentNullException">Khi sanBong là null</exception>
public bool ThemSanBong(SanBongDTO sanBong)
{
    // ...
}
```

### 3.2. Inline comments

```csharp
// ✅ Đúng - Giải thích logic phức tạp
// Kiểm tra xung đột lịch đặt sân trong khoảng thời gian yêu cầu
var lichTrung = _datSanDAL.KiemTraLichTrung(maSan, gioBatDau, gioKetThuc);

// ❌ Sai - Comment thừa
// Lấy danh sách sân
var danhSachSan = GetAllSan();  // Ai cũng hiểu rồi
```

### 3.3. TODO comments

```csharp
// TODO: Cần tối ưu query này khi dữ liệu lớn
// FIXME: Lỗi khi ngày đặt trùng ngày lễ
// HACK: Tạm thời xử lý như vậy, cần refactor sau
```

---

## 4. Quy Tắc Theo Từng Layer

### 4.1. DTO (Data Transfer Object)

```csharp
namespace VietSport.DTO
{
    /// <summary>
    /// Đối tượng truyền dữ liệu cho Sân Bóng
    /// </summary>
    public class SanBongDTO
    {
        public int MaSanBong { get; set; }
        public string TenSan { get; set; }
        public string LoaiSan { get; set; }
        public decimal GiaThue { get; set; }
        public bool TrangThai { get; set; }
        
        // Constructor mặc định
        public SanBongDTO() { }
        
        // Constructor đầy đủ
        public SanBongDTO(int maSan, string tenSan, string loaiSan, 
                          decimal giaThue, bool trangThai)
        {
            MaSanBong = maSan;
            TenSan = tenSan;
            LoaiSan = loaiSan;
            GiaThue = giaThue;
            TrangThai = trangThai;
        }
    }
}
```

### 4.2. DAL (Data Access Layer)

```csharp
namespace VietSport.DAL
{
    public class SanBongDAL
    {
        private readonly string _connectionString;

        public SanBongDAL()
        {
            _connectionString = ConfigurationManager
                .ConnectionStrings["VietSportDB"].ConnectionString;
        }

        /// <summary>
        /// Lấy tất cả sân bóng từ database
        /// </summary>
        public List<SanBongDTO> GetAll()
        {
            var result = new List<SanBongDTO>();

            using (var connection = new SqlConnection(_connectionString))
            {
                connection.Open();
                
                using (var command = new SqlCommand("sp_GetAllSanBong", connection))
                {
                    command.CommandType = CommandType.StoredProcedure;
                    
                    using (var reader = command.ExecuteReader())
                    {
                        while (reader.Read())
                        {
                            result.Add(MapToDTO(reader));
                        }
                    }
                }
            }

            return result;
        }

        /// <summary>
        /// Map từ SqlDataReader sang DTO
        /// </summary>
        private SanBongDTO MapToDTO(SqlDataReader reader)
        {
            return new SanBongDTO
            {
                MaSanBong = reader.GetInt32(reader.GetOrdinal("MaSanBong")),
                TenSan = reader.GetString(reader.GetOrdinal("TenSan")),
                LoaiSan = reader.GetString(reader.GetOrdinal("LoaiSan")),
                GiaThue = reader.GetDecimal(reader.GetOrdinal("GiaThue")),
                TrangThai = reader.GetBoolean(reader.GetOrdinal("TrangThai"))
            };
        }
    }
}
```

### 4.3. BLL (Business Logic Layer)

```csharp
namespace VietSport.BLL
{
    public class SanBongBLL
    {
        private readonly SanBongDAL _sanBongDAL;

        public SanBongBLL()
        {
            _sanBongDAL = new SanBongDAL();
        }

        /// <summary>
        /// Lấy danh sách sân bóng đang hoạt động
        /// </summary>
        public List<SanBongDTO> GetSanBongHoatDong()
        {
            return _sanBongDAL.GetAll()
                .Where(s => s.TrangThai == true)
                .ToList();
        }

        /// <summary>
        /// Thêm sân bóng mới với validation
        /// </summary>
        public bool ThemSanBong(SanBongDTO sanBong)
        {
            // Validate input
            if (sanBong == null)
                throw new ArgumentNullException(nameof(sanBong));

            if (string.IsNullOrWhiteSpace(sanBong.TenSan))
                throw new ArgumentException("Tên sân không được để trống");

            if (sanBong.GiaThue <= 0)
                throw new ArgumentException("Giá thuê phải lớn hơn 0");

            // Business logic
            // Kiểm tra trùng tên sân
            var existingSan = _sanBongDAL.GetByTen(sanBong.TenSan);
            if (existingSan != null)
                throw new InvalidOperationException("Tên sân đã tồn tại");

            return _sanBongDAL.Insert(sanBong);
        }
    }
}
```

---

## 5. SQL và Stored Procedure

### 5.1. Quy tắc đặt tên

| Loại | Prefix | Ví dụ |
|------|--------|-------|
| Table | Không có | `SanBong`, `KhachHang` |
| Stored Procedure | sp_ | `sp_GetAllSanBong`, `sp_ThemKhachHang` |
| Function | fn_ | `fn_TinhTongTien` |
| View | vw_ | `vw_DatSanChiTiet` |
| Trigger | tr_ | `tr_UpdateNgayCapNhat` |
| Index | IX_ | `IX_SanBong_TenSan` |
| Primary Key | PK_ | `PK_SanBong` |
| Foreign Key | FK_ | `FK_DatSan_SanBong` |

### 5.2. Cấu trúc Stored Procedure

```sql
-- =============================================
-- Author:      Tên tác giả
-- Create date: 2025-12-25
-- Description: Lấy danh sách sân bóng theo trạng thái
-- =============================================
CREATE PROCEDURE sp_GetSanBongByTrangThai
    @TrangThai BIT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        MaSanBong,
        TenSan,
        LoaiSan,
        GiaThue,
        TrangThai
    FROM SanBong
    WHERE TrangThai = @TrangThai
    ORDER BY TenSan;
END
GO
```

### 5.3. Quy tắc viết SQL

```sql
-- ✅ Đúng - Viết hoa keywords, format rõ ràng
SELECT 
    s.MaSanBong,
    s.TenSan,
    k.TenKhachHang,
    d.NgayDat,
    d.TongTien
FROM DatSan d
INNER JOIN SanBong s ON d.MaSanBong = s.MaSanBong
INNER JOIN KhachHang k ON d.MaKhachHang = k.MaKhachHang
WHERE d.NgayDat >= @TuNgay
    AND d.NgayDat <= @DenNgay
    AND s.TrangThai = 1
ORDER BY d.NgayDat DESC;

-- ❌ Sai
select * from datsan d, sanbong s, khachhang k 
where d.masanbong=s.masanbong and d.makhachhang=k.makhachhang
```

---

## 6. Xử Lý Lỗi

### 6.1. Try-Catch trong DAL

```csharp
public bool Insert(SanBongDTO sanBong)
{
    try
    {
        using (var connection = new SqlConnection(_connectionString))
        {
            connection.Open();
            // ... execute command
            return true;
        }
    }
    catch (SqlException ex)
    {
        // Log lỗi
        Logger.Error($"Lỗi SQL khi thêm sân bóng: {ex.Message}", ex);
        throw new DataAccessException("Không thể thêm sân bóng vào database", ex);
    }
    catch (Exception ex)
    {
        Logger.Error($"Lỗi không xác định: {ex.Message}", ex);
        throw;
    }
}
```

### 6.2. Validation trong BLL

```csharp
public void DatSan(DatSanDTO datSan)
{
    // Validate null
    if (datSan == null)
        throw new ArgumentNullException(nameof(datSan));

    // Validate business rules
    if (datSan.NgayDat < DateTime.Today)
        throw new BusinessException("Không thể đặt sân trong quá khứ");

    if (datSan.GioBatDau >= datSan.GioKetThuc)
        throw new BusinessException("Giờ bắt đầu phải nhỏ hơn giờ kết thúc");

    // Kiểm tra sân còn trống
    if (!KiemTraSanTrong(datSan.MaSanBong, datSan.NgayDat, 
                         datSan.GioBatDau, datSan.GioKetThuc))
    {
        throw new BusinessException("Sân đã được đặt trong khung giờ này");
    }

    _datSanDAL.Insert(datSan);
}
```

---

## 7. Git Workflow

### 7.1. Quy tắc đặt tên branch

```bash
# Feature mới
feat/ten-tinh-nang
feat/quan-ly-san-bong
feat/dat-san-online

# Sửa lỗi
fix/ten-loi
fix/loi-tinh-tong-tien

# Cải thiện
refactor/ten-module
refactor/toi-uu-dal

# Tài liệu
docs/ten-tai-lieu
```

### 7.2. Quy tắc commit message

```bash
# Format: <type>: <description>

# Types:
# feat     - Tính năng mới
# fix      - Sửa lỗi
# docs     - Thay đổi tài liệu
# style    - Format code (không thay đổi logic)
# refactor - Tái cấu trúc code
# test     - Thêm/sửa test
# chore    - Công việc khác (build, config)

# Ví dụ:
git commit -m "feat: thêm chức năng đặt sân online"
git commit -m "fix: sửa lỗi tính tổng tiền khi có khuyến mãi"
git commit -m "docs: cập nhật hướng dẫn cài đặt"
git commit -m "refactor: tối ưu query lấy danh sách đặt sân"
```

### 7.3. Pull Request

- Mô tả rõ ràng những gì đã thay đổi
- Đính kèm screenshot nếu có thay đổi UI
- Assign reviewer trước khi merge
- Đảm bảo build thành công trước khi tạo PR

---

## Tham Khảo

- [Microsoft C# Coding Conventions](https://docs.microsoft.com/en-us/dotnet/csharp/fundamentals/coding-style/coding-conventions)
- [.NET Naming Guidelines](https://docs.microsoft.com/en-us/dotnet/standard/design-guidelines/naming-guidelines)

---

*Cập nhật lần cuối: 25/12/2025*
