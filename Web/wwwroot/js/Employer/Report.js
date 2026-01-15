function loadRevenueByCoSo() {
	const selectedYear = document.getElementById('dp_coso_year').value;
	const selectedCoSo = document.getElementById('dp_co_so').value;

	if (!selectedYear || !selectedCoSo) {
		alert('Vui lòng chọn cơ sở và năm!');
		return;
	}

	const btnLoadRevenueByCoSo = document.getElementById('btn_load_revenue_by_co_so');
	if(btnLoadRevenueByCoSo) {
		// Tắt nút trong vòng 5s
		btnLoadRevenueByCoSo.disabled = true;
		btnLoadRevenueByCoSo.textContent = 'Đang tải...';
		setTimeout(() => {
			btnLoadRevenueByCoSo.disabled = false;
			btnLoadRevenueByCoSo.textContent = 'Xem Doanh Thu';
		}, 5000);
	}

	fetch(`/Employer/GetRevenueByCoSo?maCoSo=${selectedCoSo}&nam=${selectedYear}`)
		.then(response => response.json())
		.then(data => {
			if (data.success) {
				// Hiển thị tổng quan
				const modalBody = document.getElementById('revenue-detail-modal');
				const billTotalCount = document.getElementById('totalBillCount');
				const totalBillRevenue = document.getElementById('totalBillRevenue');
				const content = document.getElementById('revenue-detail-content');

				if(billTotalCount) billTotalCount.innerText = data.data.soHoaDon;
				if(totalBillRevenue) totalBillRevenue.innerText = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(data.data.tongDoanhThu);

				// Tạo bảng danh sách hóa đơn
				if(content) {
					let html = `
						<div class="overflow-x-auto">
							<table class="min-w-full bg-white border border-gray-200">
								<thead class="bg-[var(--main-color)] text-white">
									<tr>
										<th class="py-2 px-4 border-b text-center">Mã HĐ</th>
										<th class="py-2 px-4 border-b text-center">Tổng Cộng</th>
										<th class="py-2 px-4 border-b text-center">Hình thức thanh toán</th>
									</tr>
								</thead>
								<tbody>
					`;

					if (data.data.danhSachHoaDon && data.data.danhSachHoaDon.length > 0) {
						data.data.danhSachHoaDon.forEach(hd => {
							const tongTien = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND' }).format(hd.tongThanhToan);

							html += `
								<tr class="hover:bg-gray-50">
									<td class="py-2 px-4 border-b text-center">${hd.maHoaDon}</td>
									<td class="py-2 px-4 border-b text-center">${tongTien}</td>
									<td class="py-2 px-4 border-b text-center">${hd.hinhThucThanhToan}</td>
								</tr>
							`;
						});
					} else {
						html += `<tr><td colspan="3" class="py-4 text-center text-gray-500">Không có dữ liệu hóa đơn nào.</td></tr>`;
					}

					html += `</tbody></table></div>`;
					content.innerHTML = html;
				}

				if(modalBody) modalBody.classList.remove('hidden');
			} else {
				alert(data.message || 'Có lỗi xảy ra khi tải dữ liệu.');
			}
		})
		.catch(error => {
			console.error(error);
			alert('Lỗi kết nối đến máy chủ.');
		});	
}

document.addEventListener('DOMContentLoaded', function() {
	const cosoYear = document.getElementById('dp_coso_year');

	if (cosoYear) {
		const currentYear = new Date().getFullYear();
		for (let i = currentYear; i >= 1950; i--) {
			let opt = document.createElement('option');
			opt.value = i;
			opt.text = i;
			cosoYear.appendChild(opt);
		}
	}
})

function closeRevenueDetailModal() {
    const modal = document.getElementById('revenue-detail-modal');
    if(modal) {
        modal.classList.add('hidden');
    }
}

// Đóng modal khi click ra ngoài vùng content
window.onclick = function(event) {
    const modal = document.getElementById('revenue-detail-modal');
    if (event.target == modal) {
        modal.classList.add('hidden');
    }
}