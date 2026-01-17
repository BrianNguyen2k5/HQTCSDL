
function loadStatistics(type) {
	fetch(`/Employer/GetStatisticsReport?type=${type}`)
		.then(response => response.json())
		.then(result => {
			if (result.success) {
				if(result.data === -1) {
					// Type sai hoặc không có type này trong sql
					let el = document.getElementById(type);
					if(el) el.innerText = "N/A";
				}
				else {
					let el = document.getElementById(type);
					if(el) el.innerText = result.data;
				}
			}
		}
	)
}

document.addEventListener('DOMContentLoaded', function () {
	const statisticTypes = [
		'San_total',
		'DichVu_total',
		'TaiSan_total',
		'San_cancel',
	];

	// Chỉ load thống kê nếu đang ở trang Dashboard (hoặc trang có chứa các element này)
	// Kiểm tra xem có element đầu tiên không để đỡ call API thừa
	if(document.getElementById('San_total')) {
		statisticTypes.forEach(type => loadStatistics(type));
	}
})

function handlePriceChanging(maLoaiSan) {
	const priceInputForm = document.getElementById(`input-price-${maLoaiSan}`);
  const fieldInfoButton = document.getElementById(`field-info-button-${maLoaiSan}`);
	if(!priceInputForm || !fieldInfoButton) {
		alert('Không tìm thấy biểu mẫu thay đổi giá!');
		return;
	}
	priceInputForm.classList.remove('hidden');
  fieldInfoButton.classList.add('hidden');
}

function cancelPriceChanging(maLoaiSan) {
	const priceInputForm = document.getElementById(`input-price-${maLoaiSan}`);
  const fieldInfoButton = document.getElementById(`field-info-button-${maLoaiSan}`);
	if(!priceInputForm || !fieldInfoButton) { 
		alert('Không tìm thấy biểu mẫu thay đổi giá!');
		return;
	}
	priceInputForm.classList.add('hidden');
  fieldInfoButton.classList.remove('hidden');
}

function updateFieldPrice(maLoaiSan) {
	const newPrice = document.getElementById(`new-price-${maLoaiSan}`).value;
	if(newPrice === '' || isNaN(newPrice)) {
		alert('Vui lòng nhập giá hợp lệ!');
		return;
	}
	if(Number(newPrice) <= 10000) {
		alert('Giá thuê sân phải lớn hơn 10,000 VND!');
		return;
	}
	fetch(`/Employer/UpdateFieldPrice`, {
		method: 'PATCH',
		headers: {
			'Content-Type': 'application/json'
		},
		body: JSON.stringify({
			maLoaiSan: maLoaiSan,
			newPrice: Number(newPrice)
		})
	})
	.then(response => response.json())
	.then(result => {
		if (result.success) {
			alert(result.message);
			// Reload trang để cập nhật giá mới
			location.reload();
		}
		else {
			alert('Cập nhật giá thất bại: ' + result.message);
		}
	});
}

(function () {
	const elYear = document.getElementById('dp_year');
	const elMonth = document.getElementById('dp_month');
	const elDay = document.getElementById('dp_day');

	if (!elYear || !elMonth || !elDay) return;

	const currentYear = new Date().getFullYear();
	for (let i = currentYear; i >= 1950; i--) {
		let opt = document.createElement('option');
		opt.value = i;
		opt.text = i;
		elYear.appendChild(opt);
	}

	function populateMonths() {
		elMonth.innerHTML = '<option value="">Tháng</option>';
		for (let i = 1; i <= 12; i++) {
			let opt = document.createElement('option');
			opt.value = i;
			opt.text = 'Tháng ' + i;
			elMonth.appendChild(opt);
		}
	}

	function populateDays(year, month) {
		const selectedDay = elDay.value;
		elDay.innerHTML = '<option value="">Ngày</option>';
		const daysInMonth = new Date(year, month, 0).getDate();

		for (let i = 1; i <= daysInMonth; i++) {
			let opt = document.createElement('option');
			opt.value = i;
			opt.text = i;
			elDay.appendChild(opt);
		}

		if (selectedDay && selectedDay <= daysInMonth) {
			elDay.value = selectedDay;
		}
	}

	elYear.addEventListener('change', function () {
		if (this.value) {
			elMonth.disabled = false;
			if (elMonth.options.length <= 1) populateMonths();
			if (elMonth.value) populateDays(this.value, elMonth.value);
		} else {
			elMonth.value = '';
			elDay.value = '';
			elMonth.disabled = true;
			elDay.disabled = true;
		}
	});

	elMonth.addEventListener('change', function () {
		if (this.value) {
			elDay.disabled = false;
			populateDays(elYear.value, this.value);
		} else {
			elDay.value = '';
			elDay.disabled = true;
		}
	});
})();

function loadRevenue() {
	const nam = document.getElementById('dp_year').value;
	const thang = document.getElementById('dp_month').value;
	const ngay = document.getElementById('dp_day').value;
	console.log(nam, thang, ngay)

	if (!nam) {
		alert('Vui lòng chọn ít nhất là Năm!');
		return;
	}

	let url = `/Employer/GetRevenueReport?nam=${nam}`;
	if (thang) url += `&thang=${thang}`;
	if (ngay) url += `&ngay=${ngay}`;

	fetch(url)
		.then(response => {
			if (!response.ok) {
				throw new Error('Network response was not ok');
			}
			return response.json();
		})
		.then(data => {
			if (data.success) {
				// Format qua 3.000.000 VND
				document.getElementById('lblDoanhThu').innerText = data.formatted;
			} else {
				console.error(data.message);
			}
		})
		.catch(err => {
			console.error(err);
		});
}

