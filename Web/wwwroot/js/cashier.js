// ====================================================
// CASHIER INTERFACE JAVASCRIPT - VIETSPORT
// ====================================================

// State
let invoices = [];
let selectedInvoice = null;
let currentFilter = 'ALL';
let searchKeyword = '';
let selectedPaymentMethod = 'Tiền mặt';

// API Base URL
const API_BASE = '/api/cashier';

// ====================================================
// INITIALIZATION
// ====================================================

document.addEventListener('DOMContentLoaded', function () {
    initializeEventListeners();
    loadInvoices();
});

function initializeEventListeners() {
    // Search
    const searchInput = document.getElementById('searchInput');
    searchInput.addEventListener('input', (e) => {
        searchKeyword = e.target.value;
        filterAndRenderInvoices();
    });

    // Filter tabs
    const filterTabs = document.querySelectorAll('.filter-tab');
    filterTabs.forEach(tab => {
        tab.addEventListener('click', () => {
            filterTabs.forEach(t => t.classList.remove('active'));
            tab.classList.add('active');
            currentFilter = tab.dataset.filter;
            filterAndRenderInvoices();
        });
    });

    // Back button
    document.getElementById('backButton').addEventListener('click', () => {
        showListView();
    });

    // Payment button
    document.getElementById('paymentButton').addEventListener('click', () => {
        showPaymentModal();
    });

    // Modal controls
    document.getElementById('closeModal').addEventListener('click', () => {
        hidePaymentModal();
    });

    document.getElementById('cancelPayment').addEventListener('click', () => {
        hidePaymentModal();
    });

    document.getElementById('confirmPayment').addEventListener('click', () => {
        processPayment();
    });

    // Payment method selection
    const paymentMethods = document.querySelectorAll('.payment-method');
    paymentMethods.forEach(method => {
        method.addEventListener('click', () => {
            paymentMethods.forEach(m => m.classList.remove('active'));
            method.classList.add('active');
            selectedPaymentMethod = method.dataset.method;
        });
    });

    // Logout button
    document.getElementById('logoutButton').addEventListener('click', handleLogout);

    // Modal overlay click
    document.querySelector('.modal-overlay')?.addEventListener('click', () => {
        hidePaymentModal();
    });
}

// ====================================================
// DATA LOADING
// ====================================================

async function loadInvoices() {
    try {
        const response = await fetch(`${API_BASE}/invoices`);
        const result = await response.json();

        if (result.success) {
            invoices = result.data;
            filterAndRenderInvoices();
        } else {
            showError('Không thể tải danh sách hóa đơn');
        }
    } catch (error) {
        console.error('Error loading invoices:', error);
        showError('Lỗi kết nối đến server');
    }
}

async function loadInvoiceDetail(invoiceId) {
    try {
        const response = await fetch(`${API_BASE}/invoices/${invoiceId}`);
        const result = await response.json();

        if (result.success) {
            selectedInvoice = result.data;
            renderInvoiceDetail();
            showDetailView();
        } else {
            showError('Không thể tải chi tiết hóa đơn');
        }
    } catch (error) {
        console.error('Error loading invoice detail:', error);
        showError('Lỗi kết nối đến server');
    }
}

// ====================================================
// FILTERING & RENDERING
// ====================================================

function filterAndRenderInvoices() {
    let filtered = invoices;

    // Filter by status
    if (currentFilter === 'PENDING') {
        filtered = filtered.filter(inv => inv.trangThaiThanhToan === 'Chưa thanh toán');
    } else if (currentFilter === 'PAID') {
        filtered = filtered.filter(inv => inv.trangThaiThanhToan === 'Đã thanh toán');
    }

    // Filter by search keyword
    if (searchKeyword) {
        const keyword = searchKeyword.toLowerCase();
        filtered = filtered.filter(inv =>
            inv.maHoaDon.toString().includes(keyword) ||
            inv.tenKhachHang?.toLowerCase().includes(keyword) ||
            inv.soDienThoai?.includes(keyword) ||
            inv.email?.toLowerCase().includes(keyword)
        );
    }

    // Sort: Pending first, then by date desc
    filtered.sort((a, b) => {
        if (a.trangThaiThanhToan === 'Chưa thanh toán' && b.trangThaiThanhToan !== 'Chưa thanh toán') return -1;
        if (a.trangThaiThanhToan !== 'Chưa thanh toán' && b.trangThaiThanhToan === 'Chưa thanh toán') return 1;
        return new Date(b.ngayXuat) - new Date(a.ngayXuat);
    });

    renderInvoiceList(filtered);
}

function renderInvoiceList(invoiceList) {
    const tbody = document.getElementById('invoiceTableBody');
    const countEl = document.getElementById('invoiceCount');

    if (invoiceList.length === 0) {
        tbody.innerHTML = `
            <tr>
                <td colspan="6" style="padding: 48px; text-align: center; color: var(--gray-400);">
                    Không tìm thấy hóa đơn nào
                </td>
            </tr>
        `;
        countEl.textContent = 'Hiển thị 0 hóa đơn';
        return;
    }

    tbody.innerHTML = invoiceList.map(invoice => {
        const isPaid = invoice.trangThaiThanhToan === 'Đã thanh toán';
        const statusClass = isPaid ? 'paid' : 'pending';
        const statusText = isPaid ? 'Đã thanh toán' : 'Chưa thanh toán';

        return `
            <tr class="invoice-row" data-id="${invoice.maHoaDon}">
                <td class="invoice-id">#${invoice.maHoaDon}</td>
                <td>
                    <div class="customer-name">${invoice.tenKhachHang || 'N/A'}</div>
                    <div class="customer-phone">${invoice.soDienThoai || ''}</div>
                </td>
                <td class="invoice-date">${formatDate(invoice.ngayXuat)}</td>
                <td class="invoice-total">${formatCurrency(invoice.tongThanhToan)}</td>
                <td>
                    <span class="status-badge ${statusClass}">${statusText}</span>
                </td>
                <td class="text-right">
                    ${!isPaid ? `
                        <button class="payment-action-button" onclick="viewInvoiceDetail(${invoice.maHoaDon})">
                            <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                                <line x1="12" y1="1" x2="12" y2="23"></line>
                                <path d="M17 5H9.5a3.5 3.5 0 0 0 0 7h5a3.5 3.5 0 0 1 0 7H6"></path>
                            </svg>
                            Thanh toán
                        </button>
                    ` : ''}
                </td>
            </tr>
        `;
    }).join('');

    countEl.textContent = `Hiển thị ${invoiceList.length} hóa đơn`;

    // Add click handlers
    document.querySelectorAll('.invoice-row').forEach(row => {
        row.addEventListener('click', (e) => {
            if (!e.target.closest('.payment-action-button')) {
                const invoiceId = parseInt(row.dataset.id);
                viewInvoiceDetail(invoiceId);
            }
        });
    });
}

function renderInvoiceDetail() {
    if (!selectedInvoice) return;

    const isPaid = selectedInvoice.trangThaiThanhToan === 'Đã thanh toán';

    // Invoice ID
    document.getElementById('invoiceId').textContent = `Hóa đơn #${selectedInvoice.maHoaDon}`;

    // Status Banner
    const statusBanner = document.getElementById('statusBanner');
    statusBanner.className = `status-banner ${isPaid ? 'paid' : 'pending'}`;
    document.getElementById('statusText').textContent = isPaid ? 'ĐÃ THANH TOÁN' : 'CHƯA THANH TOÁN';
    document.getElementById('statusDate').textContent = `Ngày: ${formatDate(selectedInvoice.ngayXuat)}`;

    // Customer Info
    const customerInfo = document.getElementById('customerInfo');
    customerInfo.innerHTML = `
        <div class="customer-info-main">
            <div class="customer-icon">
                <svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                    <path d="M20 21v-2a4 4 0 0 0-4-4H8a4 4 0 0 0-4 4v2"></path>
                    <circle cx="12" cy="7" r="4"></circle>
                </svg>
            </div>
            <div class="customer-details">
                <div class="customer-name">${selectedInvoice.tenKhachHang || 'N/A'}</div>
                <div class="customer-phone">${selectedInvoice.soDienThoai || ''}</div>
            </div>
        </div>
        ${selectedInvoice.loaiUuDai ? `<div class="customer-rank">${selectedInvoice.loaiUuDai}</div>` : ''}
    `;

    // Field Info
    const fieldInfo = document.getElementById('fieldInfo');
    if (selectedInvoice.tenSan) {
        fieldInfo.innerHTML = `
            <div class="field-info-item">
                <div class="field-info-label">Sân</div>
                <div class="field-info-value">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <path d="M21 10c0 7-9 13-9 13s-9-6-9-13a9 9 0 0 1 18 0z"></path>
                        <circle cx="12" cy="10" r="3"></circle>
                    </svg>
                    ${selectedInvoice.tenSan}
                </div>
                <div class="field-info-sub">${selectedInvoice.tenLoaiSan || ''}</div>
            </div>
            <div class="field-info-item">
                <div class="field-info-label">Thời gian</div>
                <div class="field-info-value">
                    <svg width="16" height="16" viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2">
                        <circle cx="12" cy="12" r="10"></circle>
                        <polyline points="12 6 12 12 16 14"></polyline>
                    </svg>
                    ${formatTime(selectedInvoice.gioBatDau)} - ${formatTime(selectedInvoice.gioKetThuc)}
                </div>
                <div class="field-info-sub">${calculateDuration(selectedInvoice.gioBatDau, selectedInvoice.gioKetThuc)} giờ</div>
            </div>
        `;
    } else {
        fieldInfo.innerHTML = '<div class="field-info-item">Không có thông tin đặt sân</div>';
    }

    // Service Table - ONLY show actual services, NOT court rental
    const serviceTable = document.getElementById('serviceTable');
    let serviceRows = '';

    // Add service rows (NO court rental here)
    if (selectedInvoice.dichVu && selectedInvoice.dichVu.length > 0) {
        selectedInvoice.dichVu.forEach(service => {
            serviceRows += `
                <tr>
                    <td>${service.tenDichVu}</td>
                    <td>${service.donViTinh}</td>
                    <td>${service.soLuong}</td>
                    <td>${formatCurrency(service.donGia)}</td>
                    <td>${formatCurrency(service.thanhTien)}</td>
                </tr>
            `;
        });
    }

    serviceTable.innerHTML = `
        <thead>
            <tr>
                <th>Dịch vụ</th>
                <th>Đơn vị</th>
                <th>SL</th>
                <th>Đơn giá</th>
                <th>Tổng</th>
            </tr>
        </thead>
        <tbody>
            ${serviceRows || '<tr><td colspan="5" style="text-align: center; color: var(--gray-400);">Không có dịch vụ</td></tr>'}
        </tbody>
    `;

    // Payment Summary - Show detailed breakdown
    const paymentSummary = document.getElementById('paymentSummary');

    paymentSummary.innerHTML = `
        <div class="payment-row">
            <span class="payment-label">Tổng tiền sân</span>
            <span class="payment-value">${formatCurrency(selectedInvoice.tongTienSan)}</span>
        </div>
        <div class="payment-row">
            <span class="payment-label">Tổng tiền dịch vụ</span>
            <span class="payment-value">${formatCurrency(selectedInvoice.tongTienDichVu)}</span>
        </div>
        <div class="payment-row discount">
            <span class="payment-label">Tổng giảm giá${selectedInvoice.loaiUuDai ? ` (${selectedInvoice.loaiUuDai})` : ''}</span>
            <span class="payment-value">-${formatCurrency(selectedInvoice.tongTienGiamGia)}</span>
        </div>
        <div class="payment-row total">
            <span class="payment-label">Thành tiền</span>
            <span class="payment-value">${formatCurrency(selectedInvoice.tongThanhToan)}</span>
        </div>
    `;

    // Payment Button
    const paymentButton = document.getElementById('paymentButton');
    const paidBadge = document.getElementById('paidBadge');

    if (isPaid) {
        paymentButton.style.display = 'none';
        paidBadge.style.display = 'flex';
    } else {
        paymentButton.style.display = 'flex';
        paidBadge.style.display = 'none';
    }
}

// ====================================================
// VIEW NAVIGATION
// ====================================================

function showListView() {
    document.getElementById('listView').style.display = 'flex';
    document.getElementById('detailView').style.display = 'none';
    selectedInvoice = null;
}

function showDetailView() {
    document.getElementById('listView').style.display = 'none';
    document.getElementById('detailView').style.display = 'block';
}

function viewInvoiceDetail(invoiceId) {
    loadInvoiceDetail(invoiceId);
}

// ====================================================
// PAYMENT MODAL
// ====================================================

function showPaymentModal() {
    if (!selectedInvoice) return;

    document.getElementById('modalInvoiceId').textContent = `Hóa đơn #${selectedInvoice.maHoaDon}`;
    document.getElementById('modalTotal').innerHTML = `${formatCurrency(selectedInvoice.tongThanhToan).replace('₫', '')} <span>₫</span>`;

    document.getElementById('paymentModal').style.display = 'flex';
}

function hidePaymentModal() {
    document.getElementById('paymentModal').style.display = 'none';
}

async function processPayment() {
    if (!selectedInvoice) return;

    const paymentData = {
        maHoaDon: selectedInvoice.maHoaDon,
        hinhThucThanhToan: selectedPaymentMethod
        // maNhanVien will be set by backend from logged-in user
    };

    try {
        const response = await fetch(`${API_BASE}/invoices/${selectedInvoice.maHoaDon}/payment`, {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify(paymentData)
        });

        const result = await response.json();

        if (result.success) {
            hidePaymentModal();
            showSuccess(`Thanh toán thành công cho hóa đơn #${selectedInvoice.maHoaDon} qua ${selectedPaymentMethod}!`);

            // Reload data
            await loadInvoices();
            await loadInvoiceDetail(selectedInvoice.maHoaDon);
        } else {
            showError(result.message || 'Không thể xử lý thanh toán');
        }
    } catch (error) {
        console.error('Error processing payment:', error);
        showError('Lỗi kết nối đến server');
    }
}

// ====================================================
// UTILITY FUNCTIONS
// ====================================================

function formatCurrency(amount) {
    if (amount === null || amount === undefined) return '0₫';
    return amount.toLocaleString('vi-VN') + '₫';
}

function formatDate(dateString) {
    if (!dateString) return '';
    const date = new Date(dateString);
    return date.toLocaleDateString('vi-VN');
}

function formatTime(timeString) {
    if (!timeString) return '';
    // Handle TimeSpan format "HH:mm:ss"
    if (typeof timeString === 'string') {
        return timeString.substring(0, 5); // Get HH:mm
    }
    return timeString;
}

function calculateDuration(startTime, endTime) {
    if (!startTime || !endTime) return 0;

    const start = parseTime(startTime);
    const end = parseTime(endTime);

    const duration = (end.hours + end.minutes / 60) - (start.hours + start.minutes / 60);
    return duration.toFixed(1);
}

function parseTime(timeString) {
    if (!timeString) return { hours: 0, minutes: 0 };

    // Handle TimeSpan format "HH:mm:ss"
    const parts = timeString.toString().split(':');
    return {
        hours: parseInt(parts[0]),
        minutes: parseInt(parts[1])
    };
}

function showSuccess(message) {
    alert(message); // TODO: Replace with better notification
}

function showError(message) {
    alert('Lỗi: ' + message); // TODO: Replace with better notification
}

// ====================================================
// LOGOUT
// ====================================================

async function handleLogout() {
    if (!confirm('Bạn có chắc chắn muốn đăng xuất?')) {
        return;
    }

    try {
        const response = await fetch('/logout', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            }
        });

        if (response.ok) {
            window.location.href = '/login';
        } else {
            showError('Không thể đăng xuất. Vui lòng thử lại.');
        }
    } catch (error) {
        console.error('Logout error:', error);
        showError('Có lỗi xảy ra khi đăng xuất.');
    }
}

// Make viewInvoiceDetail available globally
window.viewInvoiceDetail = viewInvoiceDetail;
