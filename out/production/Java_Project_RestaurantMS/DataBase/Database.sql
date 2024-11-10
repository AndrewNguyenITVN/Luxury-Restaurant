-- Create table
Create database mysql_java;
use mysql_java;

-- Create table NguoiDung
CREATE TABLE NguoiDung (
    ID_ND INT NOT NULL,
    Email VARCHAR(50) NOT NULL,
    Matkhau VARCHAR(20) NOT NULL,
    VerifyCode VARCHAR(10) DEFAULT NULL,
    Trangthai VARCHAR(10) DEFAULT '',
    Vaitro VARCHAR(20),
    PRIMARY KEY (ID_ND),
    CHECK (Vaitro IN ('Khach Hang', 'Nhan Vien', 'Nhan Vien Kho', 'Quan Ly'))
);

-- Create table NhanVien
CREATE TABLE NhanVien (
    ID_NV INT NOT NULL,
    TenNV VARCHAR(50) NOT NULL,
    NgayVL DATE NOT NULL,
    SDT VARCHAR(50) NOT NULL,
    Chucvu VARCHAR(50),
    ID_ND INT DEFAULT NULL,
    Tinhtrang VARCHAR(20),
    Luong INT,
    PRIMARY KEY (ID_NV),
    FOREIGN KEY (ID_ND) REFERENCES NguoiDung(ID_ND),
    CHECK (Chucvu IN ('Phuc vu', 'Tiep tan', 'Thu ngan', 'Bep', 'Kho', 'Quan ly')),
    CHECK (Tinhtrang IN ('Dang lam viec', 'Da nghi viec'))
);

-- Create table KhachHang
CREATE TABLE KhachHang (
    ID_KH INT NOT NULL,
    TenKH VARCHAR(50) NOT NULL,
    Ngaythamgia DATE NOT NULL,
    Doanhso INT DEFAULT 0,
    Diemtichluy INT DEFAULT 0,
    ID_ND INT NOT NULL,
    PRIMARY KEY (ID_KH),
    FOREIGN KEY (ID_ND) REFERENCES NguoiDung(ID_ND)
);

-- Create table MonAn
CREATE TABLE MonAn (
    ID_MonAn INT NOT NULL,
    TenMon VARCHAR(50) NOT NULL,
    DonGia INT NOT NULL,
    Loai VARCHAR(50) CHECK (Loai IN ('Aries','Taurus','Gemini','Cancer','Leo','Virgo','Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces')),
    TrangThai VARCHAR(30) CHECK (TrangThai IN ('Dang kinh doanh', 'Ngung kinh doanh')),
    PRIMARY KEY (ID_MonAn)
);

-- Create table Ban
CREATE TABLE Ban (
    ID_Ban INT NOT NULL,
    TenBan VARCHAR(50) NOT NULL,
    Vitri VARCHAR(50) NOT NULL,
    Trangthai VARCHAR(50) CHECK (Trangthai IN ('Con trong', 'Dang dung bua', 'Da dat truoc')),
    PRIMARY KEY (ID_Ban)
);

-- Create table Voucher
CREATE TABLE Voucher (
    Code_Voucher VARCHAR(10) NOT NULL,
    Mota VARCHAR(50),
    Phantram INT CHECK (Phantram > 0 AND Phantram <= 100),
    LoaiMA VARCHAR(50) CHECK (LoaiMA IN ('All','Aries','Taurus','Gemini','Cancer','Leo','Virgo','Libra','Scorpio','Sagittarius','Capricorn','Aquarius','Pisces')),
    SoLuong INT,
    Diem INT,
    PRIMARY KEY (Code_Voucher)
);

-- Create table HoaDon
CREATE TABLE HoaDon (
    ID_HoaDon INT NOT NULL,
    ID_KH INT,
    ID_NV INT,
    ID_Ban INT,
    NgayHD DATE NOT NULL,
    TienMonAn INT,
    Code_Voucher VARCHAR(10),
    TienGiam INT,
    Tongtien INT,
    Trangthai VARCHAR(50) CHECK (Trangthai IN ('Chua thanh toan', 'Da thanh toan')),
    PRIMARY KEY (ID_HoaDon),
    FOREIGN KEY (ID_KH) REFERENCES KhachHang(ID_KH),
    FOREIGN KEY (ID_Ban) REFERENCES Ban(ID_Ban),
    FOREIGN KEY (ID_NV) REFERENCES NhanVien(ID_NV)
);

-- Create table CTHD
CREATE TABLE CTHD (
    ID_HoaDon INT NOT NULL,
    ID_MonAn INT NOT NULL,
    SoLuong INT NOT NULL,
    Thanhtien INT,
    PRIMARY KEY (ID_HoaDon, ID_MonAn),
    FOREIGN KEY (ID_HoaDon) REFERENCES HoaDon(ID_HoaDon),
    FOREIGN KEY (ID_MonAn) REFERENCES MonAn(ID_MonAn)
);


-- Create table PhieuNK
CREATE TABLE PhieuNK (
    ID_NK INT NOT NULL,
    ID_NV INT,
    NgayNK DATE NOT NULL,
    Tongtien INT DEFAULT 0,
    PRIMARY KEY (ID_NK),
    FOREIGN KEY (ID_NV) REFERENCES NhanVien(ID_NV)
);






















-- Thêm data cho Bảng NguoiDung

insert into NguoiDung(ID_ND, Email, Matkhau, Trangthai, Vaitro) values(1, 'luxuryrestaurant84@gmail.com', '1', 'Verified', 'Quan Ly');
INSERT INTO NguoiDung(ID_ND, Email, MatKhau, Trangthai, Vaitro) VALUES (101, 'NVHoangPhuc@gmail.com', '123', 'Verified', 'Nhan Vien');
INSERT INTO NguoiDung(ID_ND, Email, MatKhau, Trangthai, Vaitro) VALUES (102, 'NVAnhHong@gmail.com', '123', 'Verified', 'Nhan Vien Kho');
INSERT INTO NguoiDung(ID_ND, Email, MatKhau, Trangthai, Vaitro) VALUES (103, 'NVQuangDinh@gmail.com', '123', 'Verified', 'Nhan Vien');
-- Khách Hàng
INSERT INTO NguoiDung(ID_ND, Email, MatKhau, Trangthai, Vaitro) VALUES (104, 'KHThaoDuong@gmail.com', '123', 'Verified', 'Khach Hang');
INSERT INTO NguoiDung(ID_ND, Email, MatKhau, Trangthai, Vaitro) VALUES (105, 'KHTanHieu@gmail.com', '123', 'Verified', 'Khach Hang');
INSERT INTO NguoiDung(ID_ND, Email, MatKhau, Trangthai, Vaitro) VALUES (106, 'KHQuocThinh@gmail.com', '123', 'Verified', 'Khach Hang');
INSERT INTO NguoiDung(ID_ND, Email, MatKhau, Trangthai, Vaitro) VALUES (107, 'KHNhuMai@gmail.com', '123', 'Verified', 'Khach Hang');
INSERT INTO NguoiDung(ID_ND, Email, MatKhau, Trangthai, Vaitro) VALUES (108, 'KHBichHao@gmail.com', '123', 'Verified', 'Khach Hang');
INSERT INTO NguoiDung(ID_ND, Email, MatKhau, Trangthai, Vaitro) VALUES (109, 'KHMaiQuynh@gmail.com', '123', 'Verified', 'Khach Hang');
INSERT INTO NguoiDung(ID_ND, Email, MatKhau, Trangthai, Vaitro) VALUES (110, 'KHMinhQuang@gmail.com', '123', 'Verified', 'Khach Hang');
INSERT INTO NguoiDung(ID_ND, Email, MatKhau, Trangthai, Vaitro) VALUES (111, 'KHThanhHang@gmail.com', '123', 'Verified', 'Khach Hang');
INSERT INTO NguoiDung(ID_ND, Email, MatKhau, Trangthai, Vaitro) VALUES (112, 'KHThanhNhan@gmail.com', '123', 'Verified', 'Khach Hang');
INSERT INTO NguoiDung(ID_ND, Email, MatKhau, Trangthai, Vaitro) VALUES (113, 'KHPhucNguyen@gmail.com', '123', 'Verified', 'Khach Hang');

-- Thêm data cho Bảng NhanVien
-- Có tài khoản

INSERT INTO NhanVien(ID_NV, TenNV, NgayVL, SDT, Chucvu, ID_ND, Tinhtrang, Luong) VALUES (101, 'Nguyen Hoang Phuc', '2024-05-20', '0838033334', 'Tiep tan', 101, 'Dang lam viec', 6000000);
INSERT INTO NhanVien(ID_NV, TenNV, NgayVL, SDT, Chucvu, ID_ND, Tinhtrang, Luong) VALUES (102, 'Le Thi Anh Hong', '2024-05-19', '0838033234', 'Kho', 102, 'Dang lam viec', 8000000);
INSERT INTO NhanVien(ID_NV, TenNV, NgayVL, SDT, Chucvu, ID_ND, Tinhtrang, Luong) VALUES (103, 'Ho Quang Dinh', '2024-05-19', '0838033234', 'Tiep tan', 103, 'Dang lam viec', 6000000);

-- Không có tài khoản
INSERT INTO NhanVien(ID_NV, TenNV, NgayVL, SDT, Chucvu, Tinhtrang, Luong) VALUES (104, 'Ha Thao Duong', '2024-05-10', '0838033232', 'Phuc vu', 'Dang lam viec', 6000000);
INSERT INTO NhanVien(ID_NV, TenNV, NgayVL, SDT, Chucvu, Tinhtrang, Luong) VALUES (105, 'Nguyen Quoc Thinh', '2024-05-11', '0838033734', 'Phuc vu', 'Dang lam viec', 6000000);
INSERT INTO NhanVien(ID_NV, TenNV, NgayVL, SDT, Chucvu, Tinhtrang, Luong) VALUES (106, 'Truong Tan Hieu', '2024-05-12', '0838033834', 'Phuc vu', 'Dang lam viec', 6000000);
INSERT INTO NhanVien(ID_NV, TenNV, NgayVL, SDT, Chucvu, Tinhtrang, Luong) VALUES (107, 'Nguyen Thai Bao', '2024-05-10', '0838093234', 'Phuc vu', 'Dang lam viec', 6000000);
INSERT INTO NhanVien(ID_NV, TenNV, NgayVL, SDT, Chucvu, Tinhtrang, Luong) VALUES (108, 'Tran Nhat Khang', '2024-05-11', '0838133234', 'Thu ngan', 'Dang lam viec', 7000000);
INSERT INTO NhanVien(ID_NV, TenNV, NgayVL, SDT, Chucvu, Tinhtrang, Luong) VALUES (109, 'Nguyen Ngoc Luong', '2024-05-12', '0834033234', 'Bep', 'Dang lam viec', 10000000);


-- Thêm data cho Bảng KhachHang
INSERT INTO KhachHang(ID_KH, TenKH, Ngaythamgia, ID_ND) VALUES (100, 'Ha Thao Duong', '2023-05-10', 104);
INSERT INTO KhachHang(ID_KH, TenKH, Ngaythamgia, ID_ND) VALUES (101, 'Truong Tan Hieu', '2023-05-10', 105);
INSERT INTO KhachHang(ID_KH, TenKH, Ngaythamgia, ID_ND) VALUES (102, 'Nguyen Quoc Thinh', '2023-05-10', 106);
INSERT INTO KhachHang(ID_KH, TenKH, Ngaythamgia, ID_ND) VALUES (103, 'Tran Nhu Mai', '2023-05-10', 107);
INSERT INTO KhachHang(ID_KH, TenKH, Ngaythamgia, ID_ND) VALUES (104, 'Nguyen Thi Bich Hao', '2023-05-10', 108);
INSERT INTO KhachHang(ID_KH, TenKH, Ngaythamgia, ID_ND) VALUES (105, 'Nguyen Mai Quynh', '2023-05-11', 109);
INSERT INTO KhachHang(ID_KH, TenKH, Ngaythamgia, ID_ND) VALUES (106, 'Hoang Minh Quang', '2023-05-11', 110);
INSERT INTO KhachHang(ID_KH, TenKH, Ngaythamgia, ID_ND) VALUES (107, 'Nguyen Thanh Hang', '2023-05-12', 111);
INSERT INTO KhachHang(ID_KH, TenKH, Ngaythamgia, ID_ND) VALUES (108, 'Nguyen Ngoc Thanh Nhan', '2023-05-11', 112);
INSERT INTO KhachHang(ID_KH, TenKH, Ngaythamgia, ID_ND) VALUES (109, 'Hoang Thi Phuc Nguyen', '2023-05-12', 113);

-- Thêm dữ liệu cho bảng MonAn
-- Aries
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (1, 'DUI CUU NUONG XE NHO', 250000, 'Aries', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (2, 'BE SUON CUU NUONG GIAY BAC MONG CO', 230000, 'Aries', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (3, 'DUI CUU NUONG TRUNG DONG', 350000, 'Aries', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (4, 'CUU XOC LA CA RI', 129000, 'Aries', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (5, 'CUU KUNGBAO', 250000, 'Aries', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (6, 'BAP CUU NUONG CAY', 250000, 'Aries', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (7, 'CUU VIEN HAM CAY', 19000, 'Aries', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (8, 'SUON CONG NUONG MONG CO', 250000, 'Aries', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (9, 'DUI CUU LON NUONG TAI BAN', 750000, 'Aries', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (10, 'SUONG CUU NUONG SOT NAM', 450000, 'Aries', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (11, 'DUI CUU NUONG TIEU XANH', 285000, 'Aries', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (12, 'SUON CUU SOT PHO MAI', 450000, 'Aries', 'Dang kinh doanh');

-- Taurus
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (13, 'Bit tet bo My khoai tay', 179000, 'Taurus', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (14, 'Bo bit tet Uc', 169000, 'Taurus', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (15, 'Bit tet bo My BASIC', 179000, 'Taurus', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (16, 'My Y bo bam', 169000, 'Taurus', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (17, 'Thit suon Wagyu', 1180000, 'Taurus', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (18, 'Steak Thit Vai Wagyu', 1290000, 'Taurus', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (19, 'Steak Thit Bung Bo', 550000, 'Taurus', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (20, 'Tomahawk', 2390000, 'Taurus', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (21, 'Salad Romaine Nuong', 180000, 'Taurus', 'Dang kinh doanh');

-- Gemini
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (22, 'Combo Happy', 180000, 'Gemini', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (23, 'Combo Fantastic', 190000, 'Gemini', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (24, 'Combo Dreamer', 230000, 'Gemini', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (25, 'Combo Cupid', 180000, 'Gemini', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (26, 'Combo Poseidon', 190000, 'Gemini', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (27, 'Combo LUANG PRABANG', 490000, 'Gemini', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (28, 'Combo VIENTIANE', 620000, 'Gemini', 'Dang kinh doanh');

-- Cancer
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (29, 'Cua KingCrab Duc sot', 3650000, 'Cancer', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (30, 'Mai Cua KingCrab Topping Pho Mai', 2650000, 'Cancer', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (31, 'Cua KingCrab sot Tu Xuyen', 2300000, 'Cancer', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (32, 'Cua KingCrab Nuong Tu Nhien', 2550000, 'Cancer', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (33, 'Cua KingCrab Nuong Bo Toi', 2650000, 'Cancer', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (34, 'Com Mai Cua KingCrab Chien', 1850000, 'Cancer', 'Dang kinh doanh');

-- Leo
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (35, 'BOSSAM', 650000, 'Leo', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (36, 'KIMCHI PANCAKE', 350000, 'Leo', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (37, 'SPICY RICE CAKE', 250000, 'Leo', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (38, 'SPICY SAUSAGE HOTPOT', 650000, 'Leo', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (39, 'SPICY PORK', 350000, 'Leo', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (40,'MUSHROOM SPICY SILKY TOFU STEW', 350000,'Leo','Dang kinh doanh');

-- Virgo
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (41, 'Pavlova', 150000, 'Virgo', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (42, 'Kesutera', 120000, 'Virgo', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (43, 'Cremeschnitte', 250000, 'Virgo', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (44, 'Sachertorte', 150000, 'Virgo', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (45, 'Schwarzwalder Kirschtorte', 250000, 'Virgo', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (46, 'New York-Style Cheesecake', 250000, 'Virgo', 'Dang kinh doanh');

-- Libra
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (47, 'Cobb Salad', 150000, 'Libra', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (48, 'Salad Israeli', 120000, 'Libra', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (49, 'Salad Dau den', 120000, 'Libra', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (50, 'Waldorf Salad', 160000, 'Libra', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (51, 'Salad Gado-Gado', 200000, 'Libra', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (52, 'Nicoise Salad', 250000, 'Libra', 'Dang kinh doanh');

-- Scorpio
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (53, 'BULGOGI LUNCHBOX', 250000, 'Scorpio', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (54, 'CHICKEN TERIYAKI LUNCHBOX', 350000, 'Scorpio', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (55, 'SPICY PORK LUNCHBOX', 350000, 'Scorpio', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (56, 'TOFU TERIYAKI LUNCHBOX', 250000, 'Scorpio', 'Dang kinh doanh');

-- Sagittarius
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (57, 'Thit ngua do tuoi', 250000, 'Sagittarius', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (58, 'Steak Thit ngua', 350000, 'Sagittarius', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (59, 'Thit ngua ban gang', 350000, 'Sagittarius', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (60, 'Long ngua xao dua', 150000, 'Sagittarius', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (61, 'Thit ngua xao sa ot', 250000, 'Sagittarius', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (62, 'Ngua tang', 350000, 'Sagittarius', 'Dang kinh doanh');

-- Capricorn
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (63, 'Thit de xong hoi', 229000, 'Capricorn', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (64, 'Thit de xao rau ngo', 199000, 'Capricorn', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (65, 'Thit de nuong tang', 229000, 'Capricorn', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (66, 'Thit de chao', 199000, 'Capricorn', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (67, 'Thit de nuong xien', 199000, 'Capricorn', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (68, 'Nam de nuong/chao', 199000, 'Capricorn', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (69, 'Thit de xao lan', 19000, 'Capricorn', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (70, 'Dui de tan thuoc bac', 199000, 'Capricorn', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (71, 'Canh de ham duong quy', 199000, 'Capricorn', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (72, 'Chao de dau xanh', 50000, 'Capricorn', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (73, 'Thit de nhung me', 229000, 'Capricorn', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (74, 'Lau de nhu', 499000, 'Capricorn', 'Dang kinh doanh');

-- Aquarius
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (75, 'SIGNATURE WINE', 3290000, 'Aquarius', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (76, 'CHILEAN WINE', 3990000, 'Aquarius', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (77, 'ARGENTINA WINE', 2890000, 'Aquarius', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (78, 'ITALIAN WINE', 5590000, 'Aquarius', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (79, 'AMERICAN WINE', 4990000, 'Aquarius', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (80, 'CLASSIC COCKTAIL', 200000, 'Aquarius', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (81, 'SIGNATURE COCKTAIL', 250000, 'Aquarius', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (82, 'MOCKTAIL', 160000, 'Aquarius', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (83, 'JAPANESE SAKE', 1490000, 'Aquarius', 'Dang kinh doanh');


-- Thêm dữ liệu cho bảng Ban
-- Tầng 1
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (100, 'Ban T1.1', 'Tang 1', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (101, 'Ban T1.2', 'Tang 1', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (102, 'Ban T1.3', 'Tang 1', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (103, 'Ban T1.4', 'Tang 1', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (104, 'Ban T1.5', 'Tang 1', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (105, 'Ban T1.6', 'Tang 1', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (106, 'Ban T1.7', 'Tang 1', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (107, 'Ban T1.8', 'Tang 1', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (108, 'Ban T1.9', 'Tang 1', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (109, 'Ban T1.10', 'Tang 1', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (110, 'Ban T1.11', 'Tang 1', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (111, 'Ban T1.12', 'Tang 1', 'Con trong');

-- Tầng 2
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (112, 'Ban T2.1', 'Tang 2', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (113, 'Ban T2.2', 'Tang 2', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (114, 'Ban T2.3', 'Tang 2', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (115, 'Ban T2.4', 'Tang 2', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (116, 'Ban T2.5', 'Tang 2', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (117, 'Ban T2.6', 'Tang 2', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (118, 'Ban T2.7', 'Tang 2', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (119, 'Ban T2.8', 'Tang 2', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (120, 'Ban T2.9', 'Tang 2', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (121, 'Ban T2.10', 'Tang 2', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (122, 'Ban T2.11', 'Tang 2', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (123, 'Ban T2.12', 'Tang 2', 'Con trong');


-- Thêm dữ liệu cho bảng Voucher
INSERT INTO Voucher (Code_Voucher, Mota, Phantram, LoaiMA, SoLuong, Diem) VALUES ('loQy', 'giam 20%', 20, 'Aries', 10, 200);
INSERT INTO Voucher (Code_Voucher, Mota, Phantram, LoaiMA, SoLuong, Diem) VALUES ('pCfI', 'giam 30%', 30, 'Taurus', 5, 300);
INSERT INTO Voucher (Code_Voucher, Mota, Phantram, LoaiMA, SoLuong, Diem) VALUES ('pApo', 'giam 20%', 20, 'Gemini', 10, 200);
INSERT INTO Voucher (Code_Voucher, Mota, Phantram, LoaiMA, SoLuong, Diem) VALUES ('ugQx', 'giam 100%', 100, 'Virgo', 3, 500);
INSERT INTO Voucher (Code_Voucher, Mota, Phantram, LoaiMA, SoLuong, Diem) VALUES ('nxVX', 'giam 20%', 20, 'All', 5, 300);
INSERT INTO Voucher (Code_Voucher, Mota, Phantram, LoaiMA, SoLuong, Diem) VALUES ('Pwyn', 'giam 20%', 20, 'Cancer', 10, 200);
INSERT INTO Voucher (Code_Voucher, Mota, Phantram, LoaiMA, SoLuong, Diem) VALUES ('bjff', 'giam 50%', 50, 'Leo', 5, 600);
INSERT INTO Voucher (Code_Voucher, Mota, Phantram, LoaiMA, SoLuong, Diem) VALUES ('YPzJ', 'giam 20%', 20, 'Aquarius', 5, 200);
INSERT INTO Voucher (Code_Voucher, Mota, Phantram, LoaiMA, SoLuong, Diem) VALUES ('Y5g0', 'giam 30%', 30, 'Pisces', 5, 300);
INSERT INTO Voucher (Code_Voucher, Mota, Phantram, LoaiMA, SoLuong, Diem) VALUES ('7hVO', 'giam 60%', 60, 'Aries', 0, 1000);
INSERT INTO Voucher (Code_Voucher, Mota, Phantram, LoaiMA, SoLuong, Diem) VALUES ('WHLm', 'giam 20%', 20, 'Capricorn', 0, 200);
INSERT INTO Voucher (Code_Voucher, Mota, Phantram, LoaiMA, SoLuong, Diem) VALUES ('GTsC', 'giam 20%', 20, 'Leo', 0, 200);



INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai, Tongtien)
VALUES (101, 100, 100, '2024-11-09', 3000000, 0, 'Da thanh toan', 3000000);
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai, Tongtien)
VALUES (102, 104, 102, '2024-11-09', 2500000, 0, 'Da thanh toan', 2500000);
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai, Tongtien)
VALUES (103, 105, 103, '2024-11-09', 4500000, 0, 'Da thanh toan', 4500000);
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai, Tongtien)
VALUES (104, 101, 101, '2024-11-09', 5000000, 0, 'Da thanh toan', 5000000);
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai, Tongtien)
VALUES (105, 103, 120, '2024-11-09', 6000000, 0, 'Da thanh toan', 6000000);
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai, Tongtien)
VALUES (106, 104, 100, '2024-11-09', 7000000, 0, 'Da thanh toan', 7000000);
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai, Tongtien)
VALUES (107, 107, 103, '2024-11-09', 2000000, 0, 'Da thanh toan', 2000000);
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai, Tongtien)
VALUES (108, 108, 101, '2024-11-09', 3200000, 0, 'Da thanh toan', 3200000);
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai, Tongtien)
VALUES (109, 100, 100, '2024-11-09', 4000000, 0, 'Da thanh toan', 4000000);
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai, Tongtien)
VALUES (110, 103, 101, '2024-11-09', 3800000, 0, 'Da thanh toan', 3800000);
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai, Tongtien)
VALUES (111, 106, 102, '2024-11-09', 5700000, 0, 'Da thanh toan', 5700000);
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai, Tongtien)
VALUES (112, 108, 103, '2024-11-09', 4200000, 0, 'Da thanh toan', 4200000);
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai, Tongtien)
VALUES (113, 106, 102, '2024-11-09', 5200000, 0, 'Da thanh toan', 5200000);
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai, Tongtien)
VALUES (114, 108, 103, '2024-11-09', 6100000, 0, 'Da thanh toan', 6100000);
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai, Tongtien)
VALUES (115, 109, 104, '2024-11-09', 7800000, 0, 'Da thanh toan', 7800000);
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai, Tongtien)
VALUES (116, 100, 105, '2024-11-09', 4700000, 0, 'Da thanh toan', 4700000);
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai, Tongtien)
VALUES (117, 106, 106, '2024-11-09', 6800000, 0, 'Da thanh toan', 6800000);
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai, Tongtien)
VALUES (118, 102, 106, '2024-11-09', 3000000, 0, 'Da thanh toan', 3000000);
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai, Tongtien)
VALUES (119, 103, 106, '2024-11-09', 8000000, 0, 'Da thanh toan', 8000000);
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai, Tongtien)
VALUES (120, 104, 106, '2024-11-09', 7200000, 0, 'Da thanh toan', 7200000);
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai, Tongtien)
VALUES (121, 105, 106, '2024-11-09', 5200000, 0, 'Da thanh toan', 5200000);
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai, Tongtien)
VALUES (122, 107, 106, '2024-11-09', 5900000, 0, 'Da thanh toan', 5900000);





-- Insert từng dòng vào bảng CTHD
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (106, 70, 3);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (106, 75, 2);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (106, 78, 4);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (107, 32, 2);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (107, 12, 5);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (108, 12, 1);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (108, 40, 4);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (109, 45, 4);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (110, 34, 2);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (111, 41, 1);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (112, 49, 1);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (113, 52, 3);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (114, 53, 1);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (115, 56, 4);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (116, 34, 3);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (117, 22, 5);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (118, 29, 2);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (119, 42, 1);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (120, 44, 2);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (121, 46, 1);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (122, 59, 3);


-- Thêm dữ liệu cho bảng PhieuNK
INSERT INTO PhieuNK(ID_NK, ID_NV, NgayNK, Tongtien) VALUES (100, 102, '2024-11-09', 8500000);
INSERT INTO PhieuNK(ID_NK, ID_NV, NgayNK, Tongtien) VALUES (101, 102, '2024-11-09', 9200000);
INSERT INTO PhieuNK(ID_NK, ID_NV, NgayNK, Tongtien) VALUES (102, 102, '2024-11-09', 8700000);
INSERT INTO PhieuNK(ID_NK, ID_NV, NgayNK, Tongtien) VALUES (103, 102, '2024-11-09', 8800000);
INSERT INTO PhieuNK(ID_NK, ID_NV, NgayNK, Tongtien) VALUES (104, 102, '2024-11-09', 9000000);
INSERT INTO PhieuNK(ID_NK, ID_NV, NgayNK, Tongtien) VALUES (105, 102, '2024-11-09', 8700000);
INSERT INTO PhieuNK(ID_NK, ID_NV, NgayNK, Tongtien) VALUES (106, 102, '2024-11-09', 9500000);
INSERT INTO PhieuNK(ID_NK, ID_NV, NgayNK, Tongtien) VALUES (107, 102, '2024-11-09', 9800000);
INSERT INTO PhieuNK(ID_NK, ID_NV, NgayNK, Tongtien) VALUES (108, 102, '2024-11-09', 9000000);
INSERT INTO PhieuNK(ID_NK, ID_NV, NgayNK, Tongtien) VALUES (109, 102, '2024-11-09', 9200000);
INSERT INTO PhieuNK(ID_NK, ID_NV, NgayNK, Tongtien) VALUES (110, 102, '2024-11-09', 8500000);




-- Trigger Tính tổng tiền trong bảng HoaDon sau khi insert
DELIMITER $$

CREATE TRIGGER Tg_HD_Tongtien_Insert
AFTER INSERT ON HoaDon
FOR EACH ROW
BEGIN
    UPDATE HoaDon
    SET Tongtien = NEW.TienMonAn - NEW.TienGiam
    WHERE ID_HoaDon = NEW.ID_HoaDon;
END $$

DELIMITER ;
