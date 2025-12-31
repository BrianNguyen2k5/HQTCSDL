using System;
using System.Collections.Generic;

namespace Web.Models // Đổi 'Web' thành tên namespace project của bạn (VD: VietSportMVC)
{
    public class Employee
    {
        // Thêm dấu ? để cho phép null hoặc khởi tạo = string.Empty
        public string Id { get; set; } = string.Empty;
        public string Name { get; set; } = string.Empty;
        public string Branch { get; set; } = string.Empty;
        public string Position { get; set; } = string.Empty;
        public DateTime DateOfBirth { get; set; }
        public string Gender { get; set; } = string.Empty;
        public string IdNumber { get; set; } = string.Empty;
        public string Address { get; set; } = string.Empty;
        public string Phone { get; set; } = string.Empty;
        public decimal BaseSalary { get; set; }
    }

    public class EmployeeShift
    {
        public DateTime Date { get; set; }
        public string ShiftType { get; set; } = string.Empty;
        public string StartTime { get; set; } = string.Empty;
        public string EndTime { get; set; } = string.Empty;
        public string Location { get; set; } = string.Empty;
        public string Status { get; set; } = string.Empty;
    }

    public class DashboardViewModel
    {
        // Cho phép Employee có thể null ban đầu để tránh lỗi Constructor
        public Employee? Employee { get; set; }
        public List<EmployeeShift> Shifts { get; set; } = new List<EmployeeShift>();
        public DateTime SelectedMonth { get; set; }
        public int TotalShifts => Shifts.Count;
        public int ConfirmedShifts { get; set; }
        public int PendingShifts { get; set; }
    }
}