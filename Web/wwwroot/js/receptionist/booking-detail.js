
let currentBookingDetailId = null;

function viewBookingDetail(bookingId) {
    currentBookingDetailId = bookingId;
    const modal = document.getElementById('bookingDetailModal');

    // Show modal with loading state
    modal.style.display = 'flex';
    document.getElementById('detailBookingCode').textContent = '#' + bookingId;
    document.getElementById('detailStatusBadge').className = 'badge badge-outline';
    document.getElementById('detailStatusBadge').textContent = 'Đang tải...';

    // Reset data
    resetDetailView();

    // Fetch data
    fetch(`/Receptionist/LayThongTinPhieuDat?maPhieuDat=${bookingId}`)
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                renderBookingDetail(data);
            } else {
                alert(data.message || 'Không thể lấy thông tin đặt sân');
                closeBookingDetailModal();
            }
        })
        .catch(error => {
            console.error('Error fetching booking detail:', error);
            alert('Có lỗi xảy ra khi lấy thông tin');
            closeBookingDetailModal();
        });
}

function closeBookingDetailModal() {
    document.getElementById('bookingDetailModal').style.display = 'none';
    currentBookingDetailId = null;
}

function resetDetailView() {
    ['detailCustomerName', 'detailPhone', 'detailCourtName', 'detailCourtType',
        'detailDate', 'detailTime', 'detailDuration',
        'detailCourtFee', 'detailServiceFee', 'detailDiscount', 'detailTotalAmount']
        .forEach(id => document.getElementById(id).textContent = '--');

    document.getElementById('detailServicesBody').innerHTML = '<tr><td colspan="5" style="text-align: center; color: var(--color-gray-500); padding: 1rem;">Đang tải...</td></tr>';
    document.getElementById('detailInvoicesBody').innerHTML = '<tr><td colspan="5" style="text-align: center; color: var(--color-gray-500); padding: 1rem;">Đang tải...</td></tr>';

    // Hide all action buttons
    ['btnCancelBooking', 'btnCheckIn', 'btnPayment', 'btnCheckOut', 'btnAddService'].forEach(id => {
        const btn = document.getElementById(id);
        if (btn) btn.style.display = 'none';
    });
}

function renderBookingDetail(data) {
    const phieu = data.phieuDat;
    const services = data.danhSachDichVu;
    const invoices = data.danhSachHoaDon;

    // 1. Status Badge
    const statusMap = {
        'Chờ xác nhận': 'badge-warning',
        'Chờ thanh toán': 'badge-warning',
        'Đã xác nhận': 'badge-primary',
        'Đang sử dụng': 'badge-primary',
        'Hoàn thành': 'badge-success',
        'Đã hủy': 'badge-danger',
        'Vắng mặt': 'badge-danger'
    };
    const badgeClass = statusMap[phieu.trangThaiPhieu] || 'badge-outline';
    const statusBadge = document.getElementById('detailStatusBadge');
    statusBadge.className = `badge ${badgeClass}`;
    statusBadge.textContent = phieu.trangThaiPhieu;

    // 2. Info Grid
    document.getElementById('detailCustomerName').textContent = phieu.tenKhachHang;
    document.getElementById('detailPhone').textContent = phieu.soDienThoai;
    document.getElementById('detailCourtName').textContent = phieu.tenSan;
    document.getElementById('detailCourtType').textContent = phieu.tenLoaiSan;

    const date = new Date(phieu.ngayNhanSan);
    document.getElementById('detailDate').textContent = date.toLocaleDateString('vi-VN');

    // Time & Duration
    // Assuming backend sends TimeSpan strings like "09:00:00"
    const formatTime = (ts) => ts.toString().substring(0, 5);
    const startStr = formatTime(phieu.gioBatDau);
    const endStr = formatTime(phieu.gioKetThuc);
    document.getElementById('detailTime').textContent = `${startStr} - ${endStr}`;

    // Calculate duration in minutes (backend sending timespan)
    // Convert "hh:mm:ss" to minutes
    const toMinutes = (ts) => {
        const [h, m] = ts.toString().split(':').map(Number);
        return h * 60 + m;
    }
    const duration = toMinutes(phieu.gioKetThuc) - toMinutes(phieu.gioBatDau);
    document.getElementById('detailDuration').textContent = duration;

    // 3. Financials
    // Calculate totals from invoices if available, otherwise estimate
    // For now, let's use the sums from the latest invoice if exists
    let courtFee = 0;
    let serviceFee = 0;
    let discount = 0;
    let total = 0;

    if (invoices && invoices.length > 0) {
        // Sum up or take latest? Usually latest invoice has cumulative totals or we sum up multiple invoices
        // Assuming latest invoice reflects total state for now based on controller logic
        const latest = invoices[0];
        courtFee = latest.tongTienSan;
        serviceFee = latest.tongTienDichVu;
        discount = latest.tongTienGiamGia;
        total = latest.tongThanhToan;
    } else {
        // Fallback or estimate?
        // Might need a robust way to calculate if no invoice exists yet (e.g. "Chờ xác nhận")
        // But Controller usually creates invoice immediately for "Chờ thanh toán"
    }

    document.getElementById('detailCourtFee').textContent = courtFee.toLocaleString() + ' VNĐ';
    document.getElementById('detailServiceFee').textContent = serviceFee.toLocaleString() + ' VNĐ';
    document.getElementById('detailDiscount').textContent = '-' + discount.toLocaleString() + ' VNĐ';
    document.getElementById('detailTotalAmount').textContent = total.toLocaleString() + ' VNĐ';


    // 4. Services Table
    const servicesBody = document.getElementById('detailServicesBody');
    if (!services || services.length === 0) {
        servicesBody.innerHTML = '<tr><td colspan="5" style="text-align: center; color: var(--color-gray-500); padding: 1rem;">Chưa sử dụng dịch vụ nào</td></tr>';
    } else {
        servicesBody.innerHTML = services.map(s => `
            <tr>
                <td>${s.tenDichVu}</td>
                <td style="text-align: center;">${s.soLuong}</td>
                <td style="text-align: right;">${s.donGia.toLocaleString()}</td>
                <td style="text-align: right;">${(s.soLuong * s.donGia).toLocaleString()}</td>
                <td style="text-align: center;">
                    <span class="badge ${s.trangThaiThanhToan ? 'badge-success' : 'badge-warning'}">
                        ${s.trangThaiThanhToan ? 'Đã TT' : 'Chưa TT'}
                    </span>
                </td>
            </tr>
        `).join('');
    }

    // 5. Invoices Table
    const invoicesBody = document.getElementById('detailInvoicesBody');
    if (!invoices || invoices.length === 0) {
        invoicesBody.innerHTML = '<tr><td colspan="5" style="text-align: center; color: var(--color-gray-500); padding: 1rem;">Chưa có hóa đơn</td></tr>';
    } else {
        invoicesBody.innerHTML = invoices.map(inv => `
            <tr>
                <td style="font-weight: 500;">#${inv.maHoaDon}</td>
                <td>${new Date(inv.ngayXuat).toLocaleString('vi-VN')}</td>
                <td>Hóa đơn thanh toán</td>
                <td style="text-align: right; font-weight: 600;">${inv.tongThanhToan.toLocaleString()}</td>
                <td style="text-align: center;">
                    <span class="badge ${inv.trangThaiThanhToan === 'Đã thanh toán' ? 'badge-success' : 'badge-warning'}">
                        ${inv.trangThaiThanhToan}
                    </span>
                </td>
            </tr>
        `).join('');
    }

    // 6. Action Buttons
    updateActionButtons(phieu.trangThaiPhieu);
}

function updateActionButtons(status) {
    const btnCancel = document.getElementById('btnCancelBooking');
    const btnCheckIn = document.getElementById('btnCheckIn');
    const btnPayment = document.getElementById('btnPayment'); // Payment for deposit
    const btnCheckOut = document.getElementById('btnCheckOut');
    const btnAddService = document.getElementById('btnAddService');

    // Default hidden (handled in reset)

    if (status === 'Chờ xác nhận') {
        btnCancel.style.display = 'block';
        // Admin confirms -> Chờ thanh toán (backend logic)
    } else if (status === 'Chờ thanh toán') {
        btnCancel.style.display = 'block';
        btnPayment.style.display = 'block';
    } else if (status === 'Đã xác nhận') {
        btnCancel.style.display = 'block';
        btnCheckIn.style.display = 'block';
    } else if (status === 'Đang sử dụng') {
        btnAddService.style.display = 'block';
        btnCheckOut.style.display = 'block';
    }
}

// Action Handlers
function processCheckIn() {
    if (!currentBookingDetailId) return;
    if (!confirm('Xác nhận check-in cho khách hàng?')) return;

    fetch('/Receptionist/CheckIn', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ maPhieuDat: currentBookingDetailId })
    })
        .then(r => r.json())
        .then(data => {
            if (data.success) {
                alert('Check-in thành công!');
                // Reload modal data
                viewBookingDetail(currentBookingDetailId);
                // Reload parent page if needed
                if (typeof location !== 'undefined') location.reload();
            } else {
                alert(data.message);
            }
        });
}

function processCancelBooking() {
    if (!currentBookingDetailId) return;
    if (!confirm('Bạn có chắc chắn muốn hủy phiếu đặt này? Hành động này không thể hoàn tác.')) return;

    fetch('/Receptionist/CancelBooking', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ bookingId: currentBookingDetailId })
    })
        .then(r => r.json())
        .then(data => {
            alert(data.message);
            if (data.success) location.reload();
        });
}

function processCheckOut() {
    if (!currentBookingDetailId) return;
    if (!confirm('Xác nhận thanh toán và trả sân?')) return;

    fetch('/Receptionist/CheckOut', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({ maPhieuDat: currentBookingDetailId })
    })
        .then(r => r.json())
        .then(data => {
            if (data.success) {
                alert(data.message);
                location.reload();
            } else {
                alert(data.message);
            }
        });
}

function processPayment() {
    // This might be a mock for now or redirect to payment
    alert('Vui lòng thực hiện thanh toán tại quầy thu ngân (Chức năng đang cập nhật)');
}

function openAddServiceDialog() {
    alert('Chức năng thêm dịch vụ đang được phát triển');
}
