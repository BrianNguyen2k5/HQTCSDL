using Microsoft.AspNetCore.Mvc;
using HQTCSDL.Models;

namespace HQTCSDL.Controllers
{
    public class ReceptionistController : Controller
    {
        // GET: /Receptionist
        public IActionResult Index()
        {
            return View();
        }

        // GET: /Receptionist/Dashboard
        public IActionResult Dashboard()
        {
            // Mock data - sẽ thay thế bằng dữ liệu từ database
            var bookings = GetMockBookings();
            return View(bookings);
        }

        // GET: /Receptionist/Bookings
        public IActionResult Bookings()
        {
            var bookings = GetMockBookings();
            return View(bookings);
        }

        // GET: /Receptionist/Schedule
        public IActionResult Schedule()
        {
            var bookings = GetMockBookings();
            return View(bookings);
        }

        // GET: /Receptionist/POS
        public IActionResult POS()
        {
            var bookings = GetMockBookings();
            return View(bookings);
        }

        // GET: /Receptionist/Customers
        public IActionResult Customers()
        {
            var customers = GetMockCustomers();
            return View(customers);
        }

        // POST: /Receptionist/CreateBooking
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

        // POST: /Receptionist/CheckIn
        [HttpPost]
        public IActionResult CheckIn(string bookingId)
        {
            // TODO: Xử lý check-in
            return Json(new { success = true, message = "Check-in thành công" });
        }

        // POST: /Receptionist/Payment
        [HttpPost]
        public IActionResult Payment([FromBody] PaymentModel model)
        {
            // TODO: Xử lý thanh toán
            return Json(new { success = true, message = "Thanh toán thành công" });
        }

        // GET: /Receptionist/GetBookingDetail
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

        #region Mock Data Methods

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
}
