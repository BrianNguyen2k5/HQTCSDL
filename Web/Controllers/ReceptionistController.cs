using Microsoft.AspNetCore.Mvc;
using HQTCSDL.Models;
using DAL;

namespace HQTCSDL.Controllers
{
    public class ReceptionistController : Controller
    {
        private readonly IConfiguration _configuration;
        private readonly LeTanDAL _leTanDAL;
        private readonly DichVuDAL _dichVuDAL;
        private readonly KhachHangQueryDAL _khachHangQueryDAL;

        public ReceptionistController(IConfiguration configuration)
        {
            _configuration = configuration;
            _leTanDAL = new LeTanDAL(configuration);
            _dichVuDAL = new DichVuDAL(configuration);
            _khachHangQueryDAL = new KhachHangQueryDAL(configuration);
        }

        // Helper method to get MaCoSo from claims
        private string GetMaCoSo()
        {
            var maCoSo = User.FindFirst("MaCoSo")?.Value;
            if (string.IsNullOrEmpty(maCoSo))
            {
                // Fallback nếu chưa đăng nhập hoặc claim không có
                return "CS01";
            }
            return maCoSo;
        }

        // Helper method to get MaNhanVien from claims
        private string GetMaNhanVien()
        {
            var maNhanVien = User.FindFirst("MaNhanVien")?.Value;
            if (string.IsNullOrEmpty(maNhanVien))
            {
                // Fallback for testing
                return "NV0000001";
            }
            return maNhanVien;
        }

        // GET: /Receptionist
        public IActionResult Index()
        {
            return View();
        }

        // GET: /Receptionist/Dashboard
        public IActionResult Dashboard()
        {
            // Lấy danh sách phiếu đặt hôm nay
            var phieuDatList = _leTanDAL.LayDanhSachPhieuDat(ngayNhanSan: DateTime.Today);
            var bookings = phieuDatList.Select(MapToBookingViewModel).ToList();
            return View(bookings);
        }

        // GET: /Receptionist/Bookings
        public IActionResult Bookings()
        {
            // Lấy tất cả phiếu đặt
            var phieuDatList = _leTanDAL.LayDanhSachPhieuDat();
            var bookings = phieuDatList.Select(MapToBookingViewModel).ToList();
            return View(bookings);
        }

        // GET: /Receptionist/Schedule
        public IActionResult Schedule()
        {
            // Lấy tất cả phiếu đặt cho lịch
            var phieuDatList = _leTanDAL.LayDanhSachPhieuDat();
            var bookings = phieuDatList.Select(MapToBookingViewModel).ToList();
            return View(bookings);
        }

        // GET: /Receptionist/POS
        public IActionResult POS()
        {
            string maCoSo = GetMaCoSo();
            var danhSachDichVu = _dichVuDAL.LayDanhSachDichVu(maCoSo);
            return View(danhSachDichVu);
        }

        // GET: /Receptionist/Customers
        public IActionResult Customers()
        {
            // Lấy danh sách khách hàng từ database
            var khachHangList = _khachHangQueryDAL.LayDanhSachKhachHang();
            var customers = khachHangList.Select(MapToCustomerViewModel).ToList();
            return View(customers);
        }

        #region Split Billing Workflow APIs

        /// <summary>
        /// GIAI ĐOẠN 1 - Bước 1: Đặt sân trực tiếp
        /// Tạo phiếu đặt với trạng thái "Chờ xác nhận"
        /// </summary>
        [HttpPost]
        public IActionResult DatSanTrucTiep([FromBody] DatSanRequest request)
        {
            if (request == null)
            {
                return Json(new { success = false, message = "Dữ liệu không hợp lệ" });
            }

            string maNhanVien = GetMaNhanVien();

            var (success, message, maPhieuDat) = _leTanDAL.DatSanTrucTiep(
                request.MaKhachHang,
                maNhanVien,
                request.MaSan,
                request.NgayNhanSan,
                request.GioBatDau,
                request.GioKetThuc
            );

            if (success)
            {
                return Json(new
                {
                    success = true,
                    message = message,
                    maPhieuDat = maPhieuDat
                });
            }

            return Json(new { success = false, message = message });
        }

        /// <summary>
        /// GIAI ĐOẠN 1 - Bước 2: Tạo hóa đơn #1 (Tiền cọc/thanh toán trước)
        /// Chuyển phiếu từ "Chờ xác nhận" sang "Chờ thanh toán"
        /// </summary>
        [HttpPost]
        public IActionResult TaoHoaDonDatSan([FromBody] TaoHoaDonRequest request)
        {
            if (request == null || string.IsNullOrEmpty(request.MaPhieuDat))
            {
                return Json(new { success = false, message = "Mã phiếu đặt không hợp lệ" });
            }

            string maNhanVien = GetMaNhanVien();

            var (success, message, maHoaDon) = _leTanDAL.TaoHoaDon(
                request.MaPhieuDat,
                maNhanVien
            );

            if (success)
            {
                return Json(new
                {
                    success = true,
                    message = message,
                    maHoaDon = maHoaDon
                });
            }

            return Json(new { success = false, message = message });
        }

        /// <summary>
        /// GIAI ĐOẠN 3 - Bước 1: Check-in
        /// Chuyển phiếu từ "Đã xác nhận" sang "Đang sử dụng"
        /// </summary>
        [HttpPost]
        public IActionResult CheckIn([FromBody] CheckInRequest request)
        {
            if (request == null || string.IsNullOrEmpty(request.MaPhieuDat))
            {
                return Json(new { success = false, message = "Mã phiếu đặt không hợp lệ" });
            }

            var (success, message) = _leTanDAL.CheckIn(request.MaPhieuDat);

            return Json(new { success = success, message = message });
        }

        /// <summary>
        /// GIAI ĐOẠN 3 - Bước 2: Thêm dịch vụ phát sinh
        /// Thêm dịch vụ khi khách đang sử dụng sân
        /// </summary>
        [HttpPost]
        public IActionResult ThemDichVu([FromBody] ThemDichVuRequest request)
        {
            if (request == null || string.IsNullOrEmpty(request.MaPhieuDat))
            {
                return Json(new { success = false, message = "Dữ liệu không hợp lệ" });
            }

            string maNhanVien = GetMaNhanVien();

            var (success, message) = _leTanDAL.ThemDichVu(
                request.MaPhieuDat,
                request.MaDichVu,
                request.SoLuong,
                maNhanVien
            );

            return Json(new { success = success, message = message });
        }

        /// <summary>
        /// GIAI ĐOẠN 4: Check-out
        /// Tạo hóa đơn #2 (nếu có dịch vụ phát sinh) hoặc hoàn thành phiếu
        /// </summary>
        [HttpPost]
        public IActionResult CheckOut([FromBody] CheckOutRequest request)
        {
            if (request == null || string.IsNullOrEmpty(request.MaPhieuDat))
            {
                return Json(new { success = false, message = "Mã phiếu đặt không hợp lệ" });
            }

            string maNhanVien = GetMaNhanVien();

            // Gọi sp_TaoHoaDon với phiếu ở trạng thái "Đang sử dụng"
            var (success, message, maHoaDon) = _leTanDAL.TaoHoaDon(
                request.MaPhieuDat,
                maNhanVien
            );

            if (success)
            {
                return Json(new
                {
                    success = true,
                    message = message,
                    maHoaDon = maHoaDon,
                    coHoaDonPhatSinh = maHoaDon.HasValue
                });
            }

            return Json(new { success = false, message = message });
        }

        /// <summary>
        /// Lấy thông tin chi tiết phiếu đặt
        /// </summary>
        [HttpGet]
        public IActionResult LayThongTinPhieuDat(string maPhieuDat)
        {
            if (string.IsNullOrEmpty(maPhieuDat))
            {
                return Json(new { success = false, message = "Mã phiếu đặt không hợp lệ" });
            }

            var phieuDat = _leTanDAL.LayThongTinPhieuDat(maPhieuDat);
            if (phieuDat == null)
            {
                return Json(new { success = false, message = "Không tìm thấy phiếu đặt" });
            }

            var danhSachDichVu = _leTanDAL.LayDanhSachDichVuTheoPhieu(maPhieuDat);
            var danhSachHoaDon = _leTanDAL.LayDanhSachHoaDonTheoPhieu(maPhieuDat);

            return Json(new
            {
                success = true,
                phieuDat = phieuDat,
                danhSachDichVu = danhSachDichVu,
                danhSachHoaDon = danhSachHoaDon
            });
        }

        /// <summary>
        /// Lấy danh sách phiếu đặt theo điều kiện
        /// </summary>
        [HttpGet]
        public IActionResult LayDanhSachPhieuDat(string? trangThai = null, string? ngayNhanSan = null)
        {
            DateTime? ngay = null;
            if (!string.IsNullOrEmpty(ngayNhanSan) && DateTime.TryParse(ngayNhanSan, out DateTime parsedDate))
            {
                ngay = parsedDate;
            }

            var danhSach = _leTanDAL.LayDanhSachPhieuDat(trangThai, ngay);

            return Json(new
            {
                success = true,
                danhSach = danhSach
            });
        }

        /// <summary>
        /// Lấy danh sách dịch vụ để thêm vào phiếu
        /// </summary>
        [HttpGet]
        public IActionResult LayDanhSachDichVu()
        {
            string maCoSo = GetMaCoSo();
            var danhSach = _dichVuDAL.LayDanhSachDichVu(maCoSo);

            return Json(new
            {
                success = true,
                danhSach = danhSach
            });
        }

        #endregion

        // POST: /Receptionist/CreateBooking (Deprecated - Use DatSanTrucTiep instead)
        [HttpPost]
        public IActionResult CreateBooking([FromBody] BookingCreateModel model)
        {
            // TODO: Xử lý tạo booking mới
            return Json(new { success = true, message = "Đặt sân thành công" });
        }

        // POST: /Receptionist/CancelBooking
        [HttpPost]
        public IActionResult CancelBooking(string bookingId)
        {
            // TODO: Xử lý hủy booking
            return Json(new { success = true, message = "Hủy đặt sân thành công" });
        }

        // POST: /Receptionist/Payment
        [HttpPost]
        public IActionResult Payment([FromBody] PaymentModel model)
        {
            // TODO: Xử lý thanh toán (Out of scope - Thu ngân xử lý)
            return Json(new { success = true, message = "Thanh toán thành công" });
        }

        // GET: /Receptionist/GetBookingDetail (Deprecated - Use LayThongTinPhieuDat instead)
        [HttpGet]
        public IActionResult GetBookingDetail(string id)
        {
            var booking = GetMockBookings().FirstOrDefault(b => b.Id == id);
            if (booking == null)
            {
                return Json(new { success = false, message = "Không tìm thấy đặt sân" });
            }

            return Json(new { success = true, booking });
        }

        #region Mapping Helper Methods

        /// <summary>
        /// Map PhieuDatSanChiTiet từ DAL sang BookingViewModel cho View
        /// </summary>
        private BookingViewModel MapToBookingViewModel(DAL.PhieuDatSanChiTiet phieu)
        {
            // Lấy hóa đơn để tính tổng tiền
            var hoaDonList = _leTanDAL.LayDanhSachHoaDonTheoPhieu(phieu.MaPhieuDat);
            var latestHoaDon = hoaDonList.FirstOrDefault();

            // Tính tổng tiền từ hóa đơn
            decimal tongTien = latestHoaDon?.TongThanhToan ?? 0;
            decimal tienSan = latestHoaDon?.TongTienSan ?? 0;
            decimal giamGia = latestHoaDon?.TongTienGiamGia ?? 0;

            // Map trạng thái từ database sang format của view
            string status = MapDatabaseStatusToViewStatus(phieu.TrangThaiPhieu);
            
            // Xác định trạng thái thanh toán
            string paymentStatus = "unpaid";
            if (latestHoaDon != null)
            {
                paymentStatus = latestHoaDon.TrangThaiThanhToan == "Đã thanh toán" 
                    ? "paid-online" 
                    : "pay-at-counter";
            }

            // Tính thời gian
            var duration = (phieu.GioKetThuc - phieu.GioBatDau).TotalHours;
            var durationMinutes = (int)(phieu.GioKetThuc - phieu.GioBatDau).TotalMinutes;

            return new BookingViewModel
            {
                Id = phieu.MaPhieuDat,
                CourtName = phieu.TenSan,
                CourtType = MapLoaiSanToCourtType(phieu.TenLoaiSan),
                CustomerName = phieu.TenKhachHang,
                CustomerPhone = phieu.SoDienThoai,
                MemberType = "regular", // TODO: Lấy từ KhachHangChiTiet nếu cần
                StartTime = phieu.GioBatDau.ToString(@"hh\:mm"),
                EndTime = phieu.GioKetThuc.ToString(@"hh\:mm"),
                Duration = duration,
                DurationMinutes = durationMinutes,
                Status = status,
                PaymentStatus = paymentStatus,
                CreatedAt = phieu.NgayDat,
                CourtFee = tienSan,
                Discount = giamGia,
                Tax = 0 // Thuế đã tính trong TongThanhToan
            };
        }

        /// <summary>
        /// Map KhachHang từ DAL sang CustomerViewModel cho View
        /// </summary>
        private CustomerViewModel MapToCustomerViewModel(DTO.KhachHang khachHang)
        {
            // Lấy thông tin chi tiết để có ưu đãi
            var chiTiet = _khachHangQueryDAL.LayKhachHangChiTiet(khachHang.MaKhachHang);
            
            string memberType = "regular";
            if (chiTiet?.LoaiUuDai != null)
            {
                memberType = chiTiet.LoaiUuDai.ToLower() switch
                {
                    "platinum" => "platinum",
                    "gold" => "gold",
                    "hssv" => "student",
                    _ => "regular"
                };
            }

            return new CustomerViewModel
            {
                Id = khachHang.MaKhachHang,
                Name = khachHang.HoTen,
                Phone = khachHang.SoDienThoai,
                MemberType = memberType,
                DateOfBirth = khachHang.NgaySinh,
                CCCD = khachHang.SoCCCD,
                Email = khachHang.Email
            };
        }

        /// <summary>
        /// Map trạng thái từ database (tiếng Việt) sang format của view (English)
        /// </summary>
        private static string MapDatabaseStatusToViewStatus(string dbStatus)
        {
            return dbStatus switch
            {
                "Chờ xác nhận" => "booked",
                "Đã xác nhận" => "booked",
                "Chờ thanh toán" => "booked",
                "Đang sử dụng" => "active",
                "Hoàn thành" => "completed",
                "Đã hủy" => "cancelled",
                "Vắng mặt" => "cancelled",
                _ => "booked"
            };
        }

        /// <summary>
        /// Map tên loại sân sang court type code
        /// </summary>
        private static string MapLoaiSanToCourtType(string tenLoaiSan)
        {
            return tenLoaiSan switch
            {
                "Bóng đá mini" => "mini-football",
                "Futsal" => "mini-football",
                "Cầu lông" => "badminton",
                "Tennis" => "tennis",
                "Bóng rổ" => "basketball",
                _ => "mini-football"
            };
        }

        #endregion

        #region Mock Data Methods (DEPRECATED - Kept for reference)

        [Obsolete("Use MapToBookingViewModel with real data from LeTanDAL instead")]
        private List<BookingViewModel> GetMockBookings()
        {
            return new List<BookingViewModel>
            {
                new BookingViewModel
                {
                    Id = "1",
                    CourtName = "Sân bóng đá Mini 1",
                    CourtType = "mini-football",
                    CustomerName = "Nguyễn Văn An",
                    CustomerPhone = "0901234567",
                    MemberType = "gold",
                    StartTime = "09:00",
                    EndTime = "10:30",
                    Duration = 1.5,
                    DurationMinutes = 90,
                    Status = "booked",
                    PaymentStatus = "paid-online",
                    CreatedAt = DateTime.Now.AddMinutes(-5),
                    CourtFee = 100,
                    Discount = 0,
                    Tax = 10
                },
                new BookingViewModel
                {
                    Id = "2",
                    CourtName = "Sân cầu lông 1",
                    CourtType = "badminton",
                    CustomerName = "Trần Thị Bình",
                    CustomerPhone = "0912345678",
                    MemberType = "student",
                    StartTime = "14:00",
                    EndTime = "15:00",
                    Duration = 1,
                    DurationMinutes = 60,
                    Status = "booked",
                    PaymentStatus = "pay-at-counter",
                    CreatedAt = DateTime.Now.AddMinutes(-25),
                    CourtFee = 60,
                    Discount = 10,
                    Tax = 5
                },
                new BookingViewModel
                {
                    Id = "3",
                    CourtName = "Sân tennis 1",
                    CourtType = "tennis",
                    CustomerName = "Lê Minh Châu",
                    CustomerPhone = "0923456789",
                    MemberType = "platinum",
                    StartTime = "10:00",
                    EndTime = "12:00",
                    Duration = 2,
                    DurationMinutes = 120,
                    Status = "active",
                    PaymentStatus = "paid-online",
                    CreatedAt = DateTime.Now.AddMinutes(-15),
                    CourtFee = 80,
                    Discount = 15,
                    Tax = 7
                }
            };
        }

        [Obsolete("Use MapToCustomerViewModel with real data from KhachHangDAL instead")]
        private List<CustomerViewModel> GetMockCustomers()
        {
            return new List<CustomerViewModel>
            {
                new CustomerViewModel
                {
                    Id = "1",
                    Name = "Nguyễn Văn An",
                    Phone = "0901234567",
                    MemberType = "gold",
                    DateOfBirth = new DateTime(1990, 1, 15),
                    CCCD = "001234567890",
                    Email = "an.nguyen@email.com"
                },
                new CustomerViewModel
                {
                    Id = "2",
                    Name = "Trần Thị Bình",
                    Phone = "0912345678",
                    MemberType = "student",
                    DateOfBirth = new DateTime(2005, 5, 20),
                    CCCD = "001234567891",
                    Email = "binh.tran@email.com"
                },
                new CustomerViewModel
                {
                    Id = "3",
                    Name = "Lê Minh Châu",
                    Phone = "0923456789",
                    MemberType = "platinum",
                    DateOfBirth = new DateTime(1995, 8, 10),
                    CCCD = "001234567892",
                    Email = "chau.le@email.com"
                }
            };
        }

        #endregion
    }

    #region View Models

    public class BookingViewModel
    {
        public string Id { get; set; } = string.Empty;
        public string CourtName { get; set; } = string.Empty;
        public string CourtType { get; set; } = string.Empty;
        public string CustomerName { get; set; } = string.Empty;
        public string CustomerPhone { get; set; } = string.Empty;
        public string MemberType { get; set; } = string.Empty;
        public string StartTime { get; set; } = string.Empty;
        public string EndTime { get; set; } = string.Empty;
        public double Duration { get; set; }
        public int DurationMinutes { get; set; }
        public string Status { get; set; } = string.Empty;
        public string PaymentStatus { get; set; } = string.Empty;
        public DateTime CreatedAt { get; set; }
        public decimal CourtFee { get; set; }
        public decimal Discount { get; set; }
        public decimal Tax { get; set; }
        public Dictionary<string, int> Addons { get; set; } = new Dictionary<string, int>();
    }

    public class CustomerViewModel
    {
        public string Id { get; set; } = string.Empty;
        public string Name { get; set; } = string.Empty;
        public string Phone { get; set; } = string.Empty;
        public string MemberType { get; set; } = string.Empty;
        public DateTime? DateOfBirth { get; set; }
        public string? CCCD { get; set; }
        public string? Email { get; set; }
    }

    public class BookingCreateModel
    {
        public string CourtId { get; set; } = string.Empty;
        public string CustomerPhone { get; set; } = string.Empty;
        public string StartTime { get; set; } = string.Empty;
        public string EndTime { get; set; } = string.Empty;
        public Dictionary<string, int>? Addons { get; set; }
    }

    public class PaymentModel
    {
        public string BookingId { get; set; } = string.Empty;
        public decimal Amount { get; set; }
        public string PaymentMethod { get; set; } = string.Empty;
    }

    #endregion

    #region Split Billing Request Models

    /// <summary>
    /// Request model cho đặt sân trực tiếp (Giai đoạn 1 - Bước 1)
    /// </summary>
    public class DatSanRequest
    {
        public required string MaKhachHang { get; set; }
        public required string MaSan { get; set; }
        public DateTime NgayNhanSan { get; set; }
        public TimeSpan GioBatDau { get; set; }
        public TimeSpan GioKetThuc { get; set; }
    }

    /// <summary>
    /// Request model cho tạo hóa đơn (Giai đoạn 1 - Bước 2 và Giai đoạn 4)
    /// </summary>
    public class TaoHoaDonRequest
    {
        public required string MaPhieuDat { get; set; }
    }

    /// <summary>
    /// Request model cho check-in (Giai đoạn 3 - Bước 1)
    /// </summary>
    public class CheckInRequest
    {
        public required string MaPhieuDat { get; set; }
    }

    /// <summary>
    /// Request model cho thêm dịch vụ (Giai đoạn 3 - Bước 2)
    /// </summary>
    public class ThemDichVuRequest
    {
        public required string MaPhieuDat { get; set; }
        public required string MaDichVu { get; set; }
        public int SoLuong { get; set; }
    }

    /// <summary>
    /// Request model cho check-out (Giai đoạn 4)
    /// </summary>
    public class CheckOutRequest
    {
        public required string MaPhieuDat { get; set; }
    }

    #endregion
}
