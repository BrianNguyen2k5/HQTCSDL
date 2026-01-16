// VietSport Receptionist Dashboard JavaScript

// Global utilities
const VietSport = {
    // Format currency
    formatCurrency: function(amount) {
        return new Intl.NumberFormat('vi-VN', {
            style: 'currency',
            currency: 'VND'
        }).format(amount);
    },

    // Format date
    formatDate: function(date, format = 'dd/MM/yyyy') {
        const d = new Date(date);
        const day = String(d.getDate()).padStart(2, '0');
        const month = String(d.getMonth() + 1).padStart(2, '0');
        const year = d.getFullYear();
        
        if (format === 'dd/MM/yyyy') {
            return `${day}/${month}/${year}`;
        }
        return d.toLocaleDateString('vi-VN');
    },

    // Format time
    formatTime: function(date) {
        const d = new Date(date);
        return d.toLocaleTimeString('vi-VN', { hour: '2-digit', minute: '2-digit' });
    },

    // Show toast notification
    showToast: function(message, type = 'info') {
        // Simple alert for now - can be replaced with better toast library
        alert(message);
    },

    // API call helper
    api: {
        post: async function(url, data) {
            try {
                const response = await fetch(url, {
                    method: 'POST',
                    headers: {
                        'Content-Type': 'application/json',
                    },
                    body: JSON.stringify(data)
                });
                return await response.json();
            } catch (error) {
                console.error('API Error:', error);
                VietSport.showToast('Có lỗi xảy ra. Vui lòng thử lại.', 'error');
                return { success: false, message: error.message };
            }
        },

        get: async function(url) {
            try {
                const response = await fetch(url);
                return await response.json();
            } catch (error) {
                console.error('API Error:', error);
                VietSport.showToast('Có lỗi xảy ra. Vui lòng thử lại.', 'error');
                return { success: false, message: error.message };
            }
        }
    }
};

// New Booking Dialog
// Note: The actual implementation is in new-booking-dialog.js
// This function is kept here for compatibility but delegates to the real implementation
function openNewBookingDialog() {
    const dialog = document.getElementById('newBookingModal'); // Fixed: was 'newBookingDialog', should be 'newBookingModal'
    if (dialog) {
        dialog.style.display = 'flex';
        // Reset and show step 1
        if (typeof resetBookingForm === 'function') {
            resetBookingForm();
        }
        if (typeof showStep === 'function') {
            showStep(1);
        }
    }
}

// View Booking Detail
async function viewBookingDetail(bookingId) {
    const panel = document.getElementById('bookingDetailPanel');
    if (!panel) return;

    // Show panel
    panel.classList.add('open');

    // Fetch booking detail
    const result = await VietSport.api.get(`/Receptionist/GetBookingDetail?id=${bookingId}`);
    
    if (result.success && result.data) {
        const booking = result.data;
        
        // Populate booking info
        document.getElementById('detailBookingId').textContent = `#${booking.id}`;
        document.getElementById('detailCustomerName').textContent = booking.customerName;
        document.getElementById('detailCustomerPhone').textContent = booking.customerPhone;
        document.getElementById('detailCourtName').textContent = booking.courtName;
        document.getElementById('detailTime').textContent = `${booking.startTime} - ${booking.endTime}`;
        document.getElementById('detailDuration').textContent = `${booking.durationMinutes} phút`;
        
        // Status badge
        const statusBadge = document.getElementById('detailBookingStatus');
        statusBadge.className = 'badge badge-outline';
        if (booking.status === 'active') {
            statusBadge.classList.add('badge-primary');
            statusBadge.textContent = 'Đang hoạt động';
        } else if (booking.status === 'booked') {
            statusBadge.classList.add('badge-warning');
            statusBadge.textContent = 'Đã đặt';
        } else {
            statusBadge.classList.add('badge-success');
            statusBadge.textContent = 'Hoàn thành';
        }
        
        // Member type
        const memberTypeBadge = document.getElementById('detailMemberType');
        if (booking.memberType === 'platinum') {
            memberTypeBadge.textContent = '💎 Platinum';
        } else if (booking.memberType === 'gold') {
            memberTypeBadge.textContent = '🥇 Gold';
        } else if (booking.memberType === 'student') {
            memberTypeBadge.textContent = '🎓 Sinh viên';
        } else {
            memberTypeBadge.textContent = '👤 Thường';
        }
        
        // Financial info
        const totalAmount = booking.courtFee + booking.tax - booking.discount;
        document.getElementById('detailCourtFee').textContent = booking.courtFee.toLocaleString('vi-VN') + ' VNĐ';
        document.getElementById('detailAddonsFee').textContent = '0 VNĐ';
        document.getElementById('detailTax').textContent = booking.tax.toLocaleString('vi-VN') + ' VNĐ';
        document.getElementById('detailDiscount').textContent = '-' + booking.discount.toLocaleString('vi-VN') + ' VNĐ';
        document.getElementById('detailTotal').textContent = totalAmount.toLocaleString('vi-VN') + ' VNĐ';
        
        // Payment status
        const paymentStatusBadge = document.getElementById('detailPaymentStatus');
        paymentStatusBadge.className = 'badge';
        if (booking.paymentStatus === 'paid-online') {
            paymentStatusBadge.classList.add('badge-success');
            paymentStatusBadge.textContent = '✓ Đã thanh toán';
            document.getElementById('paymentCountdown').style.display = 'none';
        } else if (booking.paymentStatus === 'pay-at-counter') {
            paymentStatusBadge.classList.add('badge-warning');
            paymentStatusBadge.textContent = 'Thanh toán tại quầy';
            document.getElementById('paymentCountdown').style.display = 'block';
        } else {
            paymentStatusBadge.classList.add('badge-warning');
            paymentStatusBadge.textContent = 'Chưa thanh toán';
            document.getElementById('paymentCountdown').style.display = 'none';
        }
        
        // Show/hide action buttons based on status
        document.getElementById('checkInButton').style.display = booking.status === 'booked' ? 'block' : 'none';
        document.getElementById('paymentButton').style.display = 
            (booking.paymentStatus !== 'paid-online' && booking.status !== 'completed') ? 'block' : 'none';
        document.getElementById('cancelButton').style.display = 
            (booking.status !== 'completed' && booking.status !== 'cancelled') ? 'block' : 'none';
        
        // Store current booking ID for actions
        window.currentBookingId = booking.id;
    }
}

// Close booking detail panel
function closeBookingDetail() {
    const panel = document.getElementById('bookingDetailPanel');
    if (panel) {
        panel.classList.remove('open');
    }
}

// Auto-update current time
function updateCurrentTime() {
    const now = new Date();
    const dateElement = document.getElementById('currentDateTime');
    
    if (dateElement) {
        const options = {
            weekday: 'long',
            year: 'numeric',
            month: 'long',
            day: 'numeric',
            hour: '2-digit',
            minute: '2-digit',
            second: '2-digit'
        };
        dateElement.textContent = now.toLocaleDateString('vi-VN', options);
    }
}

// Initialize
document.addEventListener('DOMContentLoaded', function() {
    // Update time every second
    setInterval(updateCurrentTime, 1000);
    updateCurrentTime();

    // Add keyboard shortcuts
    document.addEventListener('keydown', function(e) {
        // Ctrl/Cmd + K: Quick search
        if ((e.ctrlKey || e.metaKey) && e.key === 'k') {
            e.preventDefault();
            const searchInput = document.querySelector('input[type="text"]');
            if (searchInput) {
                searchInput.focus();
            }
        }

        // Ctrl/Cmd + N: New booking
        if ((e.ctrlKey || e.metaKey) && e.key === 'n') {
            e.preventDefault();
            openNewBookingDialog();
        }
    });

    // Add smooth transitions to cards
    document.querySelectorAll('.card').forEach(card => {
        card.style.transition = 'box-shadow 0.2s, transform 0.2s';
        
        card.addEventListener('mouseenter', function() {
            if (this.style.cursor === 'pointer') {
                this.style.transform = 'translateY(-2px)';
                this.style.boxShadow = 'var(--shadow-md)';
            }
        });
        
        card.addEventListener('mouseleave', function() {
            this.style.transform = '';
            this.style.boxShadow = '';
        });
    });
});

// Export for use in other scripts
window.VietSport = VietSport;
window.openNewBookingDialog = openNewBookingDialog;
window.viewBookingDetail = viewBookingDetail;
window.closeBookingDetail = closeBookingDetail;

// Booking actions
async function checkInBooking() {
    if (!window.currentBookingId) return;
    
    const result = await VietSport.api.post('/Receptionist/CheckIn', {
        bookingId: window.currentBookingId
    });
    
    if (result.success) {
        VietSport.showToast('Check-in thành công!', 'success');
        location.reload();
    } else {
        VietSport.showToast(result.message || 'Có lỗi xảy ra', 'error');
    }
}

async function processPayment() {
    if (!window.currentBookingId) return;
    
    const result = await VietSport.api.post('/Receptionist/Payment', {
        bookingId: window.currentBookingId
    });
    
    if (result.success) {
        VietSport.showToast('Thanh toán thành công!', 'success');
        location.reload();
    } else {
        VietSport.showToast(result.message || 'Có lỗi xảy ra', 'error');
    }
}

function showCancellationConfirm() {
    const modal = document.getElementById('cancellationModal');
    if (modal) {
        modal.style.display = 'flex';
    }
}

function closeCancellationModal() {
    const modal = document.getElementById('cancellationModal');
    if (modal) {
        modal.style.display = 'none';
    }
    document.getElementById('cancellationReason').value = '';
}

async function confirmCancellation() {
    if (!window.currentBookingId) return;
    
    const reason = document.getElementById('cancellationReason').value;
    
    const result = await VietSport.api.post('/Receptionist/CancelBooking', {
        bookingId: window.currentBookingId,
        reason: reason
    });
    
    if (result.success) {
        VietSport.showToast('Hủy đặt sân thành công!', 'success');
        closeCancellationModal();
        location.reload();
    } else {
        VietSport.showToast(result.message || 'Có lỗi xảy ra', 'error');
    }
}

window.checkInBooking = checkInBooking;
window.processPayment = processPayment;
window.showCancellationConfirm = showCancellationConfirm;
window.closeCancellationModal = closeCancellationModal;
window.confirmCancellation = confirmCancellation;
