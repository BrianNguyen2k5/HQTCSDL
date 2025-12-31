using Microsoft.AspNetCore.Mvc;
using Microsoft.AspNetCore.Http; // Cần cho Session
using Web.Models; // Nhớ using namespace Models của bạn
using System;
using System.Collections.Generic;
using System.Linq;

public class EmployeeScheduleController : Controller
{
    // --- Mock Data (Giả lập Database) ---
    private static readonly List<Employee> _employees = new List<Employee>
    {
        new Employee { Id = "EMP001", Name = "Trần Thị B", Branch = "Hà Nội", Position = "Nhân viên lễ tân", DateOfBirth = new DateTime(1995, 5, 15), Gender = "Nữ", IdNumber = "012345678901", Address = "123 Đường Trần Hưng Đạo, Hà Nội", Phone = "0912345678", BaseSalary = 5000000 },
        new Employee { Id = "EMP002", Name = "Phạm Văn C", Branch = "TP.HCM", Position = "Nhân viên kỹ thuật", DateOfBirth = new DateTime(1993, 8, 20), Gender = "Nam", IdNumber = "098765432109", Address = "456 Đường Nguyễn Huệ, TP.HCM", Phone = "0987654321", BaseSalary = 6000000 },
        new Employee { Id = "EMP003", Name = "Lê Thị D", Branch = "Đà Nẵng", Position = "Nhân viên thu ngân", DateOfBirth = new DateTime(1998, 3, 10), Gender = "Nữ", IdNumber = "111222333444", Address = "789 Đường Hải Phòng, Đà Nẵng", Phone = "0901234567", BaseSalary = 5500000 }
    };

    private static readonly Dictionary<string, List<EmployeeShift>> _shifts = new Dictionary<string, List<EmployeeShift>>
    {
        { "EMP001", new List<EmployeeShift> {
            new EmployeeShift { Date = new DateTime(2024, 11, 25), ShiftType = "Sáng", StartTime = "06:00", EndTime = "12:00", Location = "Hà Nội", Status = "Xác nhận" },
            new EmployeeShift { Date = new DateTime(2024, 11, 26), ShiftType = "Chiều", StartTime = "12:00", EndTime = "18:00", Location = "Hà Nội", Status = "Xác nhận" },
            new EmployeeShift { Date = new DateTime(2024, 11, 27), ShiftType = "Tối", StartTime = "18:00", EndTime = "23:00", Location = "Hà Nội", Status = "Chờ" },
            new EmployeeShift { Date = new DateTime(2024, 11, 28), ShiftType = "Sáng", StartTime = "06:00", EndTime = "12:00", Location = "Hà Nội", Status = "Xác nhận" }
        }},
        { "EMP002", new List<EmployeeShift> {
            new EmployeeShift { Date = new DateTime(2024, 11, 25), ShiftType = "Chiều", StartTime = "12:00", EndTime = "18:00", Location = "TP.HCM", Status = "Xác nhận" }
        }}
    };

    // 1. Màn hình Login
    public IActionResult Login()
    {
        // Nếu đã đăng nhập thì chuyển thẳng vào Dashboard
        if (HttpContext.Session.GetString("EmployeeId") != null)
        {
            return RedirectToAction("Dashboard");
        }
        return View();
    }

    [HttpPost]
    public IActionResult Login(string loginId)
    {
        var emp = _employees.FirstOrDefault(e => e.Id == loginId);
        if (emp != null)
        {
            HttpContext.Session.SetString("EmployeeId", emp.Id);
            return RedirectToAction("Dashboard");
        }
        
        ViewBag.Error = "Mã nhân viên không hợp lệ";
        return View();
    }

    public IActionResult Logout()
    {
        HttpContext.Session.Clear();
        return RedirectToAction("Login");
    }

    // 2. Màn hình Dashboard (Lịch & Profile)
    public IActionResult Dashboard(int? month, int? year)
    {
        var empId = HttpContext.Session.GetString("EmployeeId");
        if (string.IsNullOrEmpty(empId)) return RedirectToAction("Login");

        var employee = _employees.FirstOrDefault(e => e.Id == empId);
        
        // Xử lý ngày tháng (Mặc định là tháng hiện tại nếu không truyền vào)
        DateTime selectedDate = DateTime.Now;
        if (month.HasValue && year.HasValue)
        {
            selectedDate = new DateTime(year.Value, month.Value, 1);
        }

        // Lấy lịch làm việc (Có thể lọc theo tháng ở đây nếu muốn)
        var allShifts = _shifts.ContainsKey(empId) ? _shifts[empId] : new List<EmployeeShift>();
        
        // Demo: Tôi không lọc data theo tháng để giống React code cũ, 
        // nhưng thực tế bạn nên dùng: allShifts.Where(s => s.Date.Month == selectedDate.Month && s.Date.Year == selectedDate.Year).ToList();

        var viewModel = new DashboardViewModel
        {
            Employee = employee,
            Shifts = allShifts,
            SelectedMonth = selectedDate,
            ConfirmedShifts = allShifts.Count(s => s.Status == "Xác nhận"),
            PendingShifts = allShifts.Count(s => s.Status == "Chờ")
        };

        return View(viewModel);
    }
}