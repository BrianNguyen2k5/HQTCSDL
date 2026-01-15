function toggleServicePriceChanging(maDichVu) {
	const servicePriceChanging = document.getElementById(`service-price-changing-${maDichVu}`);
	const serviceInfoButton = document.getElementById(`service-info-button-${maDichVu}`);
	if(!servicePriceChanging || !serviceInfoButton) {
		alert(`Không tìm thấy biểu mẫu thay đổi giá cho dịch vụ ${maDichVu}!`);
		return;
	}
	servicePriceChanging.classList.remove('hidden');
	serviceInfoButton.classList.add('hidden');
}

function cancelServicePriceChanging(maDichVu) {
	const servicePriceChanging = document.getElementById(`service-price-changing-${maDichVu}`);
	const serviceInfoButton = document.getElementById(`service-info-button-${maDichVu}`);
	if(!servicePriceChanging || !serviceInfoButton) {
		alert('Không tìm thấy biểu mẫu thay đổi giá!');
		return;
	}
	servicePriceChanging.classList.add('hidden');
	serviceInfoButton.classList.remove('hidden');
}

function updateServicePrice(maDichVu) {
	const newPrice = document.getElementById(`service-new-price-${maDichVu}`).value;
	if(newPrice === '' || isNaN(newPrice)) {
		alert('Vui lòng nhập giá hợp lệ!');
		return;
	}
	if(Number(newPrice) <= 10000) {
		alert('Giá thuê sân phải lớn hơn 10,000 VND!');
		return;
	}
	fetch(`/Employer/UpdateServicePrice`, {
		method: 'PATCH',
		headers: {
			'Content-Type': 'application/json'
		},
		body: JSON.stringify({
			maDichVu: maDichVu,
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
