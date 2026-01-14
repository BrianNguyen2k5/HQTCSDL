using System.Text;
using HQTCSDL.Models;
using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.IdentityModel.Tokens;

var builder = WebApplication.CreateBuilder(args);

//_____________________________________________________
// --- KHU VỰC ĐĂNG KÝ ---
builder.Services.AddSession(options =>
{
    options.IdleTimeout = TimeSpan.FromMinutes(30);
    options.Cookie.HttpOnly = true;
    options.Cookie.IsEssential = true;
});

builder
    .Services.AddAuthentication("MyCookieAuth")
    .AddCookie(
        "MyCookieAuth",
        options =>
        {
            options.Cookie.Name = "VietSportSession"; // Tên cookie lưu ở trình duyệt
            options.LoginPath = "/login"; // QUAN TRỌNG: Nếu chưa đăng nhập thì đá về đây
            options.AccessDeniedPath = "/forbidden"; // Nếu đăng nhập rồi mà không đủ quyền
        }
    )
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidateAudience = true,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            ValidIssuer = builder.Configuration["Jwt:Issuer"],
            ValidAudience = builder.Configuration["Jwt:Audience"],
            IssuerSigningKey = new SymmetricSecurityKey(
                Encoding.UTF8.GetBytes(builder.Configuration["Jwt:Key"])
            ),
        };
    });

// Đăng ký MVC
builder.Services.AddControllersWithViews();

//Đăng ký DTO
// Đăng ký DAL (Scoped: Tạo mới mỗi khi có request)
builder.Services.AddScoped<DAL.DatabaseConnection>();
builder.Services.AddScoped<DAL.NhanVien>();
builder.Services.AddScoped<DAL.Dashboard>();
builder.Services.AddScoped<DAL.TaiKhoan>();
builder.Services.AddScoped<DAL.KhachHang>();

// Đăng ký BLL

// --- KẾT THÚC KHU VỰC ĐĂNG KÝ ---
//_____________________________________________________
var app = builder.Build();

// Configure the HTTP request pipeline.
if (!app.Environment.IsDevelopment())
{
    app.UseExceptionHandler("/Home/Error");
    // The default HSTS value is 30 days. You may want to change this for production scenarios, see https://aka.ms/aspnetcore-hsts.
    app.UseHsts();
}

// Không gọi app.UseAuthorization() trước app.UseRouting().
// Không chèn thêm app.Map... nào giữa app.UseRouting() và app.UseAuthorization().

app.UseHttpsRedirection();
app.UseSession();
app.UseStaticFiles();
app.UseRouting();

app.UseAuthentication(); // 1. Kiểm tra xem: "Anh là ai?" (Check Cookie)
app.UseAuthorization(); // 2. Kiểm tra xem: "Anh có được vào đây không?" (Check [Authorize])

app.MapStaticAssets();

app.MapControllerRoute(name: "default", pattern: "{controller=Home}/{action=Index}/{id?}")
    .WithStaticAssets();

app.Run();
