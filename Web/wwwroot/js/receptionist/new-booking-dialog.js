// New Booking Dialog JavaScript

let currentBookingStep = 1;
let selectedCustomerData = null;
let bookingFormData = {
    customer: null,
    court: null,
    courtType: null,
    courtPrice: 0,
    date: null,
    startTime: null,
    endTime: null,
    sessions: 1,
    addons: {
        coach: 0,
        uniform: 0,
        drink: 0,
        locker: 0
    },
    paymentMethod: 'online'
};

function openNewBookingDialog() {
    document.getElementById('newBookingModal').style.display = 'flex';
    resetBookingForm();
    showStep(1);
}

function closeNewBookingDialog() {
    document.getElementById('newBookingModal').style.display = 'none';
    resetBookingForm();
}

function resetBookingForm() {
    currentBookingStep = 1;
    selectedCustomerData = null;
    bookingFormData = {
        customer: null,
        court: null,
        courtType: null,
        courtPrice: 0,
        date: null,
        startTime: null,
        endTime: null,
        sessions: 1,
        addons: {
            coach: 0,
            uniform: 0,
            drink: 0,
            locker: 0
        },
        paymentMethod: 'online'
    };

    // Reset form inputs
    document.getElementById('customerSearchInput').value = '';
    document.getElementById('newCustomerName').value = '';
    document.getElementById('newCustomerPhone').value = '';
    document.getElementById('newCustomerEmail').value = '';
    document.getElementById('newCustomerDob').value = '';
    document.getElementById('newCustomerCccd').value = '';
    document.getElementById('bookingCourt').value = '';
    document.getElementById('bookingDate').value = '';
    document.getElementById('bookingStartTime').value = '';
    document.getElementById('bookingSessions').value = '1';
    document.getElementById('addonCoach').value = '0';
    document.getElementById('addonUniform').value = '0';
    document.getElementById('addonDrink').value = '0';
    document.getElementById('addonLocker').value = '0';

    switchCustomerTab('search');
}

function showStep(step) {
    // Hide all steps
    document.getElementById('bookingStep1').style.display = 'none';
    document.getElementById('bookingStep2').style.display = 'none';
    document.getElementById('bookingStep3').style.display = 'none';
    document.getElementById('bookingStep4').style.display = 'none';

    // Show current step
    document.getElementById('bookingStep' + step).style.display = 'block';

    // Update step progress bars
    for (let i = 1; i <= 4; i++) {
        const bar = document.getElementById('stepBar' + i);
        if (bar) {
            if (i <= step) {
                bar.style.backgroundColor = '#007BFF';
            } else {
                bar.style.backgroundColor = '#e5e7eb';
            }
        }
    }

    // Update buttons
    document.getElementById('backButton').style.display = step > 1 ? 'block' : 'none';
    document.getElementById('nextButton').style.display = step < 4 ? 'block' : 'none';
    document.getElementById('submitButton').style.display = step === 4 ? 'block' : 'none';

    currentBookingStep = step;

    if (step === 4) {
        calculateSummary();
    }
}

function nextStep() {
    if (!validateStep(currentBookingStep)) {
        return;
    }

    showStep(currentBookingStep + 1);
}

function previousStep() {
    if (currentBookingStep > 1) {
        showStep(currentBookingStep - 1);
    }
}

function validateStep(step) {
    if (step === 1) {
        if (!selectedCustomerData) {
            alert('Vui lòng chọn hoặc tạo khách hàng');
            return false;
        }
        return true;
    }

    if (step === 2) {
        const court = document.getElementById('bookingCourt').value;
        const date = document.getElementById('bookingDate').value;
        const startTime = document.getElementById('bookingStartTime').value;

        if (!court) {
            alert('Vui lòng chọn sân');
            return false;
        }
        if (!date) {
            alert('Vui lòng chọn ngày');
            return false;
        }
        if (!startTime) {
            alert('Vui lòng chọn giờ bắt đầu');
            return false;
        }

        // Store data
        const [courtId, courtType, courtPrice] = court.split('|');
        bookingFormData.court = courtId;
        bookingFormData.courtType = courtType;
        bookingFormData.courtPrice = parseInt(courtPrice);
        bookingFormData.date = date;
        bookingFormData.startTime = startTime;
        bookingFormData.sessions = parseInt(document.getElementById('bookingSessions').value);

        return true;
    }

    if (step === 3) {
        // Store addons
        bookingFormData.addons.coach = parseInt(document.getElementById('addonCoach').value);
        bookingFormData.addons.uniform = parseInt(document.getElementById('addonUniform').value);
        bookingFormData.addons.drink = parseInt(document.getElementById('addonDrink').value);
        bookingFormData.addons.locker = parseInt(document.getElementById('addonLocker').value);
        return true;
    }

    return true;
}

function switchCustomerTab(tab) {
    if (tab === 'search') {
        // Update tab styles
        const searchTab = document.getElementById('searchCustomerTab');
        const newTab = document.getElementById('newCustomerTab');

        searchTab.classList.add('btn-primary', 'active');
        searchTab.classList.remove('btn-outline');
        searchTab.style.borderBottom = '3px solid #007BFF';
        searchTab.style.background = 'transparent';
        searchTab.style.color = '#007BFF';

        newTab.classList.remove('btn-primary', 'active');
        newTab.classList.add('btn-outline');
        newTab.style.borderBottom = '3px solid transparent';
        newTab.style.background = 'transparent';
        newTab.style.color = 'var(--color-gray-600)';

        document.getElementById('searchCustomerContent').style.display = 'block';
        document.getElementById('newCustomerContent').style.display = 'none';
    } else {
        // Update tab styles
        const searchTab = document.getElementById('searchCustomerTab');
        const newTab = document.getElementById('newCustomerTab');

        newTab.classList.add('btn-primary', 'active');
        newTab.classList.remove('btn-outline');
        newTab.style.borderBottom = '3px solid #007BFF';
        newTab.style.background = 'transparent';
        newTab.style.color = '#007BFF';

        searchTab.classList.remove('btn-primary', 'active');
        searchTab.classList.add('btn-outline');
        searchTab.style.borderBottom = '3px solid transparent';
        searchTab.style.background = 'transparent';
        searchTab.style.color = 'var(--color-gray-600)';

        document.getElementById('searchCustomerContent').style.display = 'none';
        document.getElementById('newCustomerContent').style.display = 'block';
    }
}

function createNewCustomer() {
    const name = document.getElementById('newCustomerName').value.trim();
    const phone = document.getElementById('newCustomerPhone').value.trim();
    const email = document.getElementById('newCustomerEmail').value.trim();
    const dob = document.getElementById('newCustomerDob').value;
    const cccd = document.getElementById('newCustomerCccd').value.trim();
    const memberType = document.getElementById('newCustomerMemberType').value;

    // Validation
    if (!name || !phone || !dob || !cccd) {
        alert('Vui lòng điền đầy đủ các trường bắt buộc (*)');
        return;
    }

    // Phone validation
    if (!/^[0-9]{10}$/.test(phone)) {
        alert('Số điện thoại không hợp lệ. Vui lòng nhập 10 chữ số.');
        return;
    }

    // Create customer object
    const newCustomer = {
        id: 'NEW_' + Date.now(),
        name: name,
        phone: phone,
        email: email,
        dob: dob,
        cccd: cccd,
        memberType: memberType
    };

    // Select the new customer
    selectCustomer(newCustomer);

    // Show success message
    alert('Tạo khách hàng mới thành công!');

    // Switch back to search tab
    switchCustomerTab('search');
}

function searchCustomers() {
    const searchTerm = document.getElementById('customerSearchInput').value.trim();

    if (searchTerm.length < 3) {
        document.getElementById('customerSearchResults').innerHTML =
            `<div style="text-align: center; color: var(--color-gray-500); padding: 2rem;">
                <i class="fas fa-search" style="font-size: 2rem; margin-bottom: 0.5rem; opacity: 0.5;"></i>
                <p>Nhập ít nhất 3 ký tự để tìm kiếm</p>
            </div>`;
        return;
    }

    // Mock search - replace with actual API call
    const mockCustomers = [
        { id: '1', name: 'Nguyễn Văn An', phone: '0901234567', memberType: 'gold' },
        { id: '2', name: 'Trần Thị Bình', phone: '0912345678', memberType: 'student' },
        { id: '3', name: 'Lê Minh Châu', phone: '0923456789', memberType: 'platinum' },
        { id: '4', name: 'Phạm Hoàng Anh', phone: '0934567890', memberType: 'general' }
    ];

    const filtered = mockCustomers.filter(c =>
        c.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
        c.phone.includes(searchTerm)
    );

    if (filtered.length === 0) {
        document.getElementById('customerSearchResults').innerHTML =
            `<div style="text-align: center; color: var(--color-gray-500); padding: 2rem;">
                <i class="fas fa-user-slash" style="font-size: 2rem; margin-bottom: 0.5rem; opacity: 0.5;"></i>
                <p>Không tìm thấy khách hàng</p>
                <p style="font-size: 0.875rem;">Thử tìm với từ khóa khác hoặc tạo khách hàng mới</p>
            </div>`;
        return;
    }

    const getMemberBadge = (memberType) => {
        const badges = {
            'platinum': { icon: '💎', text: 'Platinum', class: 'badge-primary' },
            'gold': { icon: '🥇', text: 'Gold', class: 'badge-warning' },
            'silver': { icon: '🥈', text: 'Silver', class: 'badge-outline' },
            'student': { icon: '🎓', text: 'Sinh viên', class: 'badge-outline' },
            'general': { icon: '👤', text: 'Thường', class: 'badge-outline' }
        };
        const badge = badges[memberType] || badges['general'];
        return `<span class="badge ${badge.class}">${badge.icon} ${badge.text}</span>`;
    };

    document.getElementById('customerSearchResults').innerHTML = filtered.map(customer => `
        <div class="card" style="margin-bottom: 0.75rem; cursor: pointer; transition: all 0.2s; border: 2px solid transparent;" 
             onclick='selectCustomer(${JSON.stringify(customer)})'
             onmouseover="this.style.borderColor='#007BFF'; this.style.backgroundColor='#f0f9ff';"
             onmouseout="this.style.borderColor='transparent'; this.style.backgroundColor='white';">
            <div style="display: flex; justify-content: space-between; align-items: center;">
                <div style="flex: 1;">
                    <div style="font-weight: 600; font-size: 1rem; color: var(--color-gray-900); margin-bottom: 0.25rem;">${customer.name}</div>
                    <div style="font-size: 0.875rem; color: var(--color-gray-600);">
                        <i class="fas fa-phone" style="margin-right: 0.25rem;"></i>${customer.phone}
                    </div>
                </div>
                ${getMemberBadge(customer.memberType)}
            </div>
        </div>
    `).join('');
}

function selectCustomer(customer) {
    selectedCustomerData = customer;
    bookingFormData.customer = customer;

    document.getElementById('selectedCustomerName').textContent = customer.name;
    document.getElementById('selectedCustomerPhone').textContent = customer.phone;
    document.getElementById('selectedCustomerInfo').style.display = 'block';
    document.getElementById('searchCustomerContent').style.display = 'none';
}

function clearSelectedCustomer() {
    selectedCustomerData = null;
    bookingFormData.customer = null;
    document.getElementById('selectedCustomerInfo').style.display = 'none';
    document.getElementById('searchCustomerContent').style.display = 'block';
    document.getElementById('customerSearchInput').value = '';
}

function updateCourtInfo() {
    const court = document.getElementById('bookingCourt').value;
    if (!court) {
        document.getElementById('durationText').textContent = '--';
        document.getElementById('endTimeText').textContent = '--';
        return;
    }

    const [courtId, courtType, courtPrice] = court.split('|');

    const durations = {
        'mini-football': 90,
        'badminton': 60,
        'tennis': 120
    };

    const duration = durations[courtType];
    document.getElementById('durationText').textContent = duration + ' phút/buổi';

    updateEndTime();
}

function updateEndTime() {
    const startTime = document.getElementById('bookingStartTime').value;
    const sessions = parseInt(document.getElementById('bookingSessions').value);
    const court = document.getElementById('bookingCourt').value;

    if (!startTime || !court) {
        document.getElementById('endTimeText').textContent = '--';
        return;
    }

    const [courtId, courtType, courtPrice] = court.split('|');
    const durations = {
        'mini-football': 90,
        'badminton': 60,
        'tennis': 120
    };

    const duration = durations[courtType] * sessions;
    const [hours, mins] = startTime.split(':').map(Number);
    const totalMins = hours * 60 + mins + duration;
    const endHours = Math.floor(totalMins / 60);
    const endMins = totalMins % 60;

    const endTime = `${String(endHours).padStart(2, '0')}:${String(endMins).padStart(2, '0')}`;
    bookingFormData.endTime = endTime;

    document.getElementById('endTimeText').textContent = endTime;
}

function updateAddon(type, change) {
    const input = document.getElementById('addon' + type.charAt(0).toUpperCase() + type.slice(1));
    const current = parseInt(input.value);
    const newValue = Math.max(0, current + change);
    input.value = newValue;
}

function updatePaymentMethod() {
    const method = document.querySelector('input[name="paymentMethod"]:checked').value;
    bookingFormData.paymentMethod = method;

    document.getElementById('counterPaymentWarning').style.display = method === 'counter' ? 'block' : 'none';
}

function calculateSummary() {
    const courtFee = bookingFormData.courtPrice * bookingFormData.sessions;
    const addonsFee =
        bookingFormData.addons.coach * 50 +
        bookingFormData.addons.uniform * 10 +
        bookingFormData.addons.drink * 3 +
        bookingFormData.addons.locker * 5;

    const subtotal = courtFee + addonsFee;
    const tax = Math.round(subtotal * 0.1);

    // Member discount
    const discountRates = {
        'platinum': 0.20,
        'gold': 0.10,
        'silver': 0.05,
        'student': 0.10,
        'general': 0
    };

    const discountRate = discountRates[bookingFormData.customer?.memberType || 'general'];
    const discount = Math.round(subtotal * discountRate);

    const total = subtotal + tax - discount;

    document.getElementById('summaryCourtFee').textContent = courtFee.toLocaleString() + ' VNĐ';
    document.getElementById('summaryAddonsFee').textContent = addonsFee.toLocaleString() + ' VNĐ';
    document.getElementById('summaryTax').textContent = tax.toLocaleString() + ' VNĐ';
    document.getElementById('summaryDiscount').textContent = '-' + discount.toLocaleString() + ' VNĐ';
    document.getElementById('summaryTotal').textContent = total.toLocaleString() + ' VNĐ';
}

function submitBooking() {
    const payload = {
        customerPhone: bookingFormData.customer.phone,
        courtId: bookingFormData.court,
        date: bookingFormData.date,
        startTime: bookingFormData.startTime,
        endTime: bookingFormData.endTime,
        sessions: bookingFormData.sessions,
        addons: bookingFormData.addons,
        paymentMethod: bookingFormData.paymentMethod
    };

    fetch('/Receptionist/CreateBooking', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('Đặt sân thành công!');
                closeNewBookingDialog();
                location.reload();
            } else {
                alert(data.message || 'Có lỗi xảy ra. Vui lòng thử lại.');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Có lỗi xảy ra. Vui lòng thử lại.');
        });
}

// Set default date to today
document.addEventListener('DOMContentLoaded', function () {
    const today = new Date().toISOString().split('T')[0];
    if (document.getElementById('bookingDate')) {
        document.getElementById('bookingDate').value = today;
    }
});
