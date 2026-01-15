// New Booking Dialog JavaScript

let currentBookingStep = 1;
let selectedCustomerData = null;
let availableServices = []; // Store services from API
let bookingFormData = {
    customer: null,
    court: null,
    courtType: null,
    courtPrice: 0,
    date: null,
    startTime: null,
    endTime: null,
    sessions: 1,
    services: {} // Dynamic services: { maDichVu: quantity }
};

function openNewBookingDialog() {
    document.getElementById('newBookingModal').style.display = 'flex';
    resetBookingForm();
    showStep(1);
    // Services will be loaded when user reaches step 3
}

function openBookingWithDetails(dateStr, timeStr, courtId) {
    openNewBookingDialog();

    // Pre-fill data for Step 2
    const dateInput = document.getElementById('bookingDate');
    const timeInput = document.getElementById('bookingStartTime');

    // Format date string to YYYY-MM-DD if needed (assuming input is YYYY-MM-DD)
    if (dateInput) dateInput.value = dateStr;
    if (timeInput) timeInput.value = timeStr;

    // Select the court based on ID (matching the start of the value string "id|type|price")
    const courtSelect = document.getElementById('bookingCourt');
    if (courtSelect) {
        for (let i = 0; i < courtSelect.options.length; i++) {
            if (courtSelect.options[i].value.startsWith(courtId + '|')) {
                courtSelect.selectedIndex = i;
                // Trigger update to set duration and end time
                updateCourtInfo();
                break;
            }
        }
    }
}

function closeNewBookingDialog() {
    document.getElementById('newBookingModal').style.display = 'none';
    resetBookingForm();
}

function resetBookingForm() {
    currentBookingStep = 1;
    selectedCustomerData = null;
    availableServices = [];
    bookingFormData = {
        customer: null,
        court: null,
        courtType: null,
        courtPrice: 0,
        date: null,
        startTime: null,
        endTime: null,
        sessions: 1,
        services: {}
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

    // Load services when reaching step 3 (only load once)
    if (step === 3 && availableServices.length === 0) {
        loadServices();
    }

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
        // Services are already stored in bookingFormData.services via updateServiceQuantity
        // No validation needed here
        return true;
    }

    return true;
}

// Load services from API
function loadServices() {
    console.log('Loading services...');
    fetch('/Receptionist/LayDanhSachDichVu')
        .then(response => {
            console.log('Response status:', response.status);
            return response.json();
        })
        .then(data => {
            console.log('API Response:', data);

            // Support both camelCase and PascalCase
            const serviceList = data.danhSach || data.DanhSach;
            const success = data.success || data.Success;

            console.log('Service list:', serviceList);
            console.log('Success:', success);

            if (success && serviceList) {
                availableServices = serviceList;
                console.log('Available services:', availableServices);
                renderServices();
            } else {
                console.error('Failed to load services. Success:', success, 'ServiceList:', serviceList);
                document.getElementById('servicesContainer').innerHTML =
                    `<div style="grid-column: 1 / -1; text-align: center; padding: 2rem; color: var(--color-gray-500);">
                        <i class="fas fa-exclamation-circle" style="font-size: 2rem; margin-bottom: 0.5rem;"></i>
                        <p>Không thể tải danh sách dịch vụ</p>
                    </div>`;
            }
        })
        .catch(error => {
            console.error('Error loading services:', error);
            document.getElementById('servicesContainer').innerHTML =
                `<div style="grid-column: 1 / -1; text-align: center; padding: 2rem; color: var(--color-gray-500);">
                    <i class="fas fa-exclamation-circle" style="font-size: 2rem; margin-bottom: 0.5rem;"></i>
                    <p>Có lỗi xảy ra khi tải dịch vụ</p>
                </div>`;
        });
}

// Render services dynamically
function renderServices() {
    console.log('renderServices() called, availableServices:', availableServices);
    const container = document.getElementById('servicesContainer');
    console.log('servicesContainer element:', container);

    if (!container) {
        console.error('servicesContainer not found in DOM!');
        return;
    }

    if (availableServices.length === 0) {
        console.log('No services available, showing empty message');
        container.innerHTML =
            `<div style="grid-column: 1 / -1; text-align: center; padding: 2rem; color: var(--color-gray-500);">
                <i class="fas fa-info-circle" style="font-size: 2rem; margin-bottom: 0.5rem;"></i>
                <p>Không có dịch vụ nào</p>
            </div>`;
        return;
    }

    console.log('Rendering', availableServices.length, 'services');

    // Service icons mapping
    const serviceIcons = {
        'Nước uống': '🥤',
        'Đồ uống': '🥤',
        'Thuê dụng cụ': '⚽',
        'Dụng cụ': '⚽',
        'Thuê trang phục': '👕',
        'Trang phục': '👕',
        'Phòng tắm': '🚿',
        'Tủ đồ': '🔐'
    };

    container.innerHTML = availableServices.map(service => {
        // Support both camelCase (from new JSON config) and PascalCase (legacy)
        const tenDichVu = service.tenDichVu || service.TenDichVu;
        const loaiDichVu = service.loaiDichVu || service.LoaiDichVu;
        const donGia = service.donGia || service.DonGia;
        const donViTinh = service.donViTinh || service.DonViTinh;
        const maDichVu = (service.maDichVu || service.MaDichVu).trim(); // Trim whitespace from database
        const soLuongTonKho = service.soLuongTonKho || service.SoLuongTonKho;

        // Find matching icon
        let icon = '📦'; // default
        for (const [key, value] of Object.entries(serviceIcons)) {
            if (tenDichVu.includes(key) || loaiDichVu.includes(key)) {
                icon = value;
                break;
            }
        }

        return `
            <div class="card">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 0.5rem;">
                    <span>${icon} ${tenDichVu}</span>
                    <span>${donGia.toLocaleString()} VNĐ/${donViTinh}</span>
                </div>
                <div style="display: flex; gap: 0.5rem; align-items: center;">
                    <button class="btn btn-outline" style="padding: 0.25rem 0.75rem;" onclick="updateServiceQuantity('${maDichVu}', -1)">-</button>
                    <input type="number" class="input" style="width: 60px; text-align: center;" id="service_${maDichVu}" value="0" readonly />
                    <button class="btn btn-outline" style="padding: 0.25rem 0.75rem;" onclick="updateServiceQuantity('${maDichVu}', 1)">+</button>
                </div>
                <div style="font-size: 0.75rem; color: var(--color-gray-500); margin-top: 0.25rem;">
                    Tồn kho: ${soLuongTonKho}
                </div>
            </div>
        `;
    }).join('');
}

// Update service quantity
function updateServiceQuantity(maDichVu, change) {
    maDichVu = maDichVu.trim(); // Trim whitespace
    const input = document.getElementById('service_' + maDichVu);
    const service = availableServices.find(s =>
        ((s.maDichVu || s.MaDichVu) + '').trim() === maDichVu
    );

    if (!service) {
        console.error('Service not found:', maDichVu);
        return;
    }

    const soLuongTonKho = service.soLuongTonKho || service.SoLuongTonKho;
    const current = parseInt(input.value) || 0;
    const newValue = Math.max(0, Math.min(soLuongTonKho, current + change));

    input.value = newValue;
    bookingFormData.services[maDichVu] = newValue;

    // Remove if quantity is 0
    if (newValue === 0) {
        delete bookingFormData.services[maDichVu];
    }
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

    // CCCD validation
    if (!/^[0-9]{12}$/.test(cccd)) {
        alert('Số CCCD không hợp lệ. Vui lòng nhập 12 chữ số.');
        return;
    }

    // Call API to create customer
    fetch('/Receptionist/CreateNewCustomer', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
            name: name,
            phone: phone,
            email: email || null,
            dateOfBirth: dob,
            cccd: cccd
        })
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                // Select the new customer
                selectCustomer(data.customer);

                // Show success message
                alert(data.message || 'Tạo khách hàng mới thành công!');

                // Switch back to search tab
                switchCustomerTab('search');
            } else {
                alert(data.message || 'Có lỗi xảy ra. Vui lòng thử lại.');
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('Có lỗi xảy ra. Vui lòng thử lại.');
        });
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

    // Show loading
    document.getElementById('customerSearchResults').innerHTML =
        `<div style="text-align: center; color: var(--color-gray-500); padding: 2rem;">
            <i class="fas fa-spinner fa-spin" style="font-size: 2rem; margin-bottom: 0.5rem;"></i>
            <p>Đang tìm kiếm...</p>
        </div>`;

    // Call API to search customers
    fetch(`/Receptionist/SearchCustomers?searchTerm=${encodeURIComponent(searchTerm)}`)
        .then(response => response.json())
        .then(data => {
            if (!data.success) {
                document.getElementById('customerSearchResults').innerHTML =
                    `<div style="text-align: center; color: var(--color-gray-500); padding: 2rem;">
                        <i class="fas fa-exclamation-circle" style="font-size: 2rem; margin-bottom: 0.5rem; opacity: 0.5;"></i>
                        <p>${data.message}</p>
                    </div>`;
                return;
            }

            const customers = data.customers || [];

            if (customers.length === 0) {
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

            document.getElementById('customerSearchResults').innerHTML = customers.map(customer => `
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
        })
        .catch(error => {
            console.error('Error:', error);
            document.getElementById('customerSearchResults').innerHTML =
                `<div style="text-align: center; color: var(--color-gray-500); padding: 2rem;">
                    <i class="fas fa-exclamation-circle" style="font-size: 2rem; margin-bottom: 0.5rem; opacity: 0.5;"></i>
                    <p>Có lỗi xảy ra. Vui lòng thử lại.</p>
                </div>`;
        });
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
        'tennis': 120,
        'basketball': 60,
        'futsal': 60
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
        'tennis': 120,
        'basketball': 90,
        'futsal': 90
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

function calculateSummary() {
    const courtFee = bookingFormData.courtPrice * bookingFormData.sessions;

    // Calculate services fee dynamically
    let servicesFee = 0;
    for (const [maDichVu, quantity] of Object.entries(bookingFormData.services)) {
        const service = availableServices.find(s =>
            ((s.maDichVu || s.MaDichVu) + '').trim() === maDichVu.trim()
        );
        if (service && quantity > 0) {
            const donGia = service.donGia || service.DonGia;
            servicesFee += donGia * quantity;
        }
    }

    const subtotal = courtFee + servicesFee;

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

    const total = subtotal - discount;

    document.getElementById('summaryCourtFee').textContent = courtFee.toLocaleString() + ' VNĐ';
    document.getElementById('summaryAddonsFee').textContent = servicesFee.toLocaleString() + ' VNĐ';
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
        services: bookingFormData.services
    };

    fetch('/Receptionist/CreateBooking', {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(payload)
    })
        .then(response => response.json())
        .then(data => {
            if (data.success) {
                alert('Đặt sân thành công! Vui lòng thanh toán.');
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

// Load courts from API
function loadCourts() {
    fetch('/Receptionist/GetAvailableCourts')
        .then(response => response.json())
        .then(data => {
            if (data.success && data.courts) {
                const courtSelect = document.getElementById('bookingCourt');
                if (courtSelect) {
                    // Clear existing options except the first placeholder
                    courtSelect.innerHTML = '<option value="">-- Chọn sân --</option>';

                    // Add courts
                    data.courts.forEach(court => {
                        const option = document.createElement('option');
                        // Store court info in the value as: maSan|courtType|price
                        option.value = `${court.id}|${court.type}|${court.price}`;
                        option.textContent = `${court.name} - ${court.typeName} (${court.price.toLocaleString()} VNĐ/${court.duration} phút)`;
                        courtSelect.appendChild(option);
                    });
                }
            }
        })
        .catch(error => {
            console.error('Error loading courts:', error);
        });
}

// Set default date to today and load courts
document.addEventListener('DOMContentLoaded', function () {
    const today = new Date().toISOString().split('T')[0];
    if (document.getElementById('bookingDate')) {
        document.getElementById('bookingDate').value = today;
    }

    // Load courts when page loads
    loadCourts();
});
