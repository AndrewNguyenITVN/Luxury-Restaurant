

-- Create table
-- Drop tables if they exist
DROP TABLE IF EXISTS NguoiDung;
DROP TABLE IF EXISTS NhanVien;
DROP TABLE IF EXISTS KhachHang;

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
    ID_NQL INT,
    Tinhtrang VARCHAR(20),
    PRIMARY KEY (ID_NV),
    FOREIGN KEY (ID_ND) REFERENCES NguoiDung(ID_ND),
    FOREIGN KEY (ID_NQL) REFERENCES NhanVien(ID_NV),
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

-- Drop tables if they exist to avoid errors
DROP TABLE IF EXISTS CTXK, PhieuXK, CTNK, PhieuNK, Kho, NguyenLieu, CTHD, HoaDon, Voucher, Ban, MonAn;

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
    ID_Ban INT,
    NgayHD DATE NOT NULL,
    TienMonAn INT,
    Code_Voucher VARCHAR(10),
    TienGiam INT,
    Tongtien INT,
    Trangthai VARCHAR(50) CHECK (Trangthai IN ('Chua thanh toan', 'Da thanh toan')),
    PRIMARY KEY (ID_HoaDon),
    FOREIGN KEY (ID_KH) REFERENCES KhachHang(ID_KH),
    FOREIGN KEY (ID_Ban) REFERENCES Ban(ID_Ban)
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

-- Create table NguyenLieu
CREATE TABLE NguyenLieu (
    ID_NL INT NOT NULL,
    TenNL VARCHAR(50) NOT NULL,
    Dongia INT NOT NULL,
    Donvitinh VARCHAR(50) CHECK (Donvitinh IN ('g','kg','ml','l')),
    PRIMARY KEY (ID_NL)
);

-- Create table Kho
CREATE TABLE Kho (
    ID_NL INT NOT NULL,
    SLTon INT DEFAULT 0,
    PRIMARY KEY (ID_NL),
    FOREIGN KEY (ID_NL) REFERENCES NguyenLieu(ID_NL)
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

-- Create table CTNK
CREATE TABLE CTNK (
    ID_NK INT NOT NULL,
    ID_NL INT NOT NULL,
    SoLuong INT NOT NULL,
    Thanhtien INT,
    PRIMARY KEY (ID_NK, ID_NL),
    FOREIGN KEY (ID_NK) REFERENCES PhieuNK(ID_NK),
    FOREIGN KEY (ID_NL) REFERENCES NguyenLieu(ID_NL)
);

-- Create table PhieuXK
CREATE TABLE PhieuXK (
    ID_XK INT NOT NULL,
    ID_NV INT,
    NgayXK DATE NOT NULL,
    PRIMARY KEY (ID_XK),
    FOREIGN KEY (ID_NV) REFERENCES NhanVien(ID_NV)
);

-- Create table CTXK
CREATE TABLE CTXK (
    ID_XK INT NOT NULL,
    ID_NL INT NOT NULL,
    SoLuong INT NOT NULL,
    PRIMARY KEY (ID_XK, ID_NL),
    FOREIGN KEY (ID_XK) REFERENCES PhieuXK(ID_XK),
    FOREIGN KEY (ID_NL) REFERENCES NguyenLieu(ID_NL)
);

– Trigger

-- Trigger kiểm tra khách hàng có tối đa một hóa đơn chưa thanh toán
DELIMITER //
CREATE TRIGGER Tg_SLHD_CTT
BEFORE INSERT ON HoaDon
FOR EACH ROW
BEGIN
    DECLARE v_count INT;
    
    SELECT COUNT(*) INTO v_count
    FROM HoaDon
    WHERE ID_KH = NEW.ID_KH AND TrangThai = 'Chua thanh toan';
    
    IF v_count > 0 THEN
        SIGNAL SQLSTATE '45000'
        SET MESSAGE_TEXT = 'Mỗi khách hàng chỉ được có tối đa một hóa đơn có trạng thái chưa thanh toán';
    END IF;
END;
//
DELIMITER ;

-- Trigger cập nhật thành tiền trong CTHD dựa trên số lượng và đơn giá
DELIMITER //
CREATE TRIGGER Tg_CTHD_Thanhtien_Insert
BEFORE INSERT ON CTHD
FOR EACH ROW
BEGIN
    DECLARE gia DECIMAL(10,2);
    
    -- Fetch DonGia
    SELECT DonGia INTO gia
    FROM MonAn
    WHERE MonAn.ID_MonAn = NEW.ID_MonAn;

    -- If DonGia is not found, set ThanhTien to 0
    IF gia IS NULL THEN
        SET NEW.ThanhTien = 0;
    ELSE
        SET NEW.ThanhTien = NEW.SoLuong * gia;
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER Tg_CTHD_Thanhtien_Update
BEFORE UPDATE ON CTHD
FOR EACH ROW
BEGIN
    DECLARE gia DECIMAL(10,2);
    
    -- Fetch DonGia
    SELECT DonGia INTO gia
    FROM MonAn
    WHERE MonAn.ID_MonAn = NEW.ID_MonAn;

    -- If DonGia is not found, set ThanhTien to 0
    IF gia IS NULL THEN
        SET NEW.ThanhTien = 0;
    ELSE
        SET NEW.ThanhTien = NEW.SoLuong * gia;
    END IF;
END;
//
DELIMITER ;



-- Trigger cập nhật tổng tiền món ăn trong HoaDon khi CTHD thay đổi
DELIMITER //
CREATE TRIGGER Tg_HD_TienMonAn_Insert
AFTER INSERT ON CTHD
FOR EACH ROW
BEGIN
    UPDATE HoaDon 
    SET TienMonAn = TienMonAn + NEW.ThanhTien 
    WHERE ID_HoaDon = NEW.ID_HoaDon;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER Tg_HD_TienMonAn_Update
AFTER UPDATE ON CTHD
FOR EACH ROW
BEGIN
    UPDATE HoaDon 
    SET TienMonAn = TienMonAn + NEW.ThanhTien - OLD.ThanhTien 
    WHERE ID_HoaDon = NEW.ID_HoaDon;
END;
//
DELIMITER ;


-- Trigger cập nhật tiền giảm giá trong HoaDon khi thêm hoặc cập nhật món ăn trong CTHD
DELIMITER //
CREATE TRIGGER Tg_HD_TienGiam_Insert
AFTER INSERT ON CTHD
FOR EACH ROW
BEGIN
    DECLARE v_code VARCHAR(255);
    DECLARE v_loaiMA VARCHAR(255);
    DECLARE MA_Loai VARCHAR(255);

    IF (NEW.ID_HoaDon IS NOT NULL) THEN
        -- Find Voucher Code and applicable food type
        SELECT HoaDon.Code_Voucher, Voucher.LoaiMA INTO v_code, v_loaiMA
        FROM HoaDon
        LEFT JOIN Voucher ON Voucher.Code_Voucher = HoaDon.Code_Voucher
        WHERE ID_HoaDon = NEW.ID_HoaDon;

        -- Find food type
        SELECT Loai INTO MA_Loai
        FROM MonAn 
        WHERE ID_MonAn = NEW.ID_MonAn;

        IF v_code IS NOT NULL AND (v_loaiMA = 'All' OR v_loaiMA = MA_Loai) THEN
            UPDATE HoaDon 
            SET TienGiam = TienGiam + Tinhtiengiam(NEW.ThanhTien, v_code) 
            WHERE ID_HoaDon = NEW.ID_HoaDon;
        END IF;
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER Tg_HD_TienGiam_Update
AFTER UPDATE ON CTHD
FOR EACH ROW
BEGIN
    DECLARE v_code VARCHAR(255);
    DECLARE v_loaiMA VARCHAR(255);
    DECLARE MA_Loai VARCHAR(255);

    IF (NEW.ID_HoaDon IS NOT NULL) THEN
        -- Find Voucher Code and applicable food type
        SELECT HoaDon.Code_Voucher, Voucher.LoaiMA INTO v_code, v_loaiMA
        FROM HoaDon
        LEFT JOIN Voucher ON Voucher.Code_Voucher = HoaDon.Code_Voucher
        WHERE ID_HoaDon = NEW.ID_HoaDon;

        -- Find food type
        SELECT Loai INTO MA_Loai
        FROM MonAn 
        WHERE ID_MonAn = NEW.ID_MonAn;

        IF v_code IS NOT NULL AND (v_loaiMA = 'All' OR v_loaiMA = MA_Loai) THEN
            UPDATE HoaDon 
            SET TienGiam = TienGiam + Tinhtiengiam(NEW.ThanhTien, v_code) - Tinhtiengiam(OLD.ThanhTien, v_code)
            WHERE ID_HoaDon = NEW.ID_HoaDon;
        END IF;
    END IF;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER Tg_HD_TienGiam_Delete
AFTER DELETE ON CTHD
FOR EACH ROW
BEGIN
    DECLARE v_code VARCHAR(255);
    DECLARE v_loaiMA VARCHAR(255);
    DECLARE MA_Loai VARCHAR(255);

    IF (OLD.ID_HoaDon IS NOT NULL) THEN
        -- Find Voucher Code and applicable food type
        SELECT HoaDon.Code_Voucher, Voucher.LoaiMA INTO v_code, v_loaiMA
        FROM HoaDon
        LEFT JOIN Voucher ON Voucher.Code_Voucher = HoaDon.Code_Voucher
        WHERE ID_HoaDon = OLD.ID_HoaDon;

        -- Find food type
        SELECT Loai INTO MA_Loai
        FROM MonAn 
        WHERE ID_MonAn = OLD.ID_MonAn;

        IF v_code IS NOT NULL AND (v_loaiMA = 'All' OR v_loaiMA = MA_Loai) THEN
            UPDATE HoaDon 
            SET TienGiam = TienGiam - Tinhtiengiam(OLD.ThanhTien, v_code) 
            WHERE ID_HoaDon = OLD.ID_HoaDon;
        END IF;
    END IF;
END;
//
DELIMITER ;


-- Trigger tính tổng tiền trong HoaDon dựa trên tiền món ăn và tiền giảm
DELIMITER //
CREATE TRIGGER Tg_HD_Tongtien_Insert
AFTER INSERT ON HoaDon
FOR EACH ROW
BEGIN
    UPDATE HoaDon 
    SET Tongtien = NEW.TienMonAn - NEW.TienGiam 
    WHERE ID_HoaDon = NEW.ID_HoaDon;
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER Tg_HD_Tongtien_Update
AFTER UPDATE ON HoaDon
FOR EACH ROW
BEGIN
    UPDATE HoaDon 
    SET Tongtien = NEW.TienMonAn - NEW.TienGiam 
    WHERE ID_HoaDon = NEW.ID_HoaDon;
END;
//
DELIMITER ;


-- Trigger cập nhật doanh số và điểm tích lũy khách hàng khi hóa đơn hoàn tất
DELIMITER //
CREATE TRIGGER Tg_KH_DoanhsovaDTL
AFTER UPDATE ON HoaDon
FOR EACH ROW
BEGIN
    IF NEW.Trangthai = 'Da thanh toan' THEN
        UPDATE KhachHang SET Doanhso = Doanhso + NEW.Tongtien WHERE ID_KH = NEW.ID_KH;
        UPDATE KhachHang SET Diemtichluy = Diemtichluy + ROUND(NEW.Tongtien * 0.00005) WHERE ID_KH = NEW.ID_KH;
    END IF;
END;
//
DELIMITER ;

-- Trigger cập nhật trạng thái bàn khi khách hàng thêm hóa đơn mới
DELIMITER //
CREATE TRIGGER Tg_TrangthaiBan_Insert
AFTER INSERT ON HoaDon
FOR EACH ROW
BEGIN
    IF NEW.Trangthai = 'Chua thanh toan' THEN 
        UPDATE Ban SET Trangthai = 'Dang dung bua' WHERE ID_Ban = NEW.ID_Ban;
    ELSE 
        UPDATE Ban SET Trangthai = 'Con trong' WHERE ID_Ban = NEW.ID_Ban;
    END IF; 
END;
//
DELIMITER ;

DELIMITER //
CREATE TRIGGER Tg_TrangthaiBan_Update
AFTER UPDATE ON HoaDon
FOR EACH ROW
BEGIN
    IF NEW.Trangthai = 'Chua thanh toan' THEN 
        UPDATE Ban SET Trangthai = 'Dang dung bua' WHERE ID_Ban = NEW.ID_Ban;
    ELSE 
        UPDATE Ban SET Trangthai = 'Con trong' WHERE ID_Ban = NEW.ID_Ban;
    END IF; 
END;
//
DELIMITER ;




-- Trigger khi thêm một nguyên liệu mới, tự động thêm vào kho
DELIMITER //
CREATE TRIGGER Tg_Kho_ThemNL
AFTER INSERT ON NguyenLieu
FOR EACH ROW
BEGIN
    INSERT INTO Kho(ID_NL) VALUES(NEW.ID_NL);
END;
//
DELIMITER ;

-- Procedure

DELIMITER //
CREATE PROCEDURE KH_ThemKH(IN tenKH VARCHAR(255), IN NgayTG DATE, IN ID_ND INT)
BEGIN
    DECLARE v_ID_KH INT;

    SELECT MIN(ID_KH) + 1 INTO v_ID_KH
    FROM KHACHHANG
    WHERE ID_KH + 1 NOT IN (SELECT ID_KH FROM KHACHHANG);

    INSERT INTO KHACHHANG(ID_KH, TenKH, Ngaythamgia, ID_ND) VALUES (v_ID_KH, tenKH, NgayTG, ID_ND);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE NV_ThemNV(IN tenNV VARCHAR(255), IN NgayVL DATE, IN SDT VARCHAR(15), IN Chucvu VARCHAR(100), IN ID_NQL INT, IN Tinhtrang VARCHAR(50))
BEGIN
    DECLARE v_ID_NV INT;

    SELECT MIN(ID_NV) + 1 INTO v_ID_NV
    FROM NHANVIEN
    WHERE ID_NV + 1 NOT IN (SELECT ID_NV FROM NHANVIEN);

    INSERT INTO NHANVIEN(ID_NV, TenNV, NgayVL, SDT, Chucvu, ID_NQL, Tinhtrang) 
    VALUES (v_ID_NV, tenNV, NgayVL, SDT, Chucvu, ID_NQL, Tinhtrang);
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE NV_XoaNV(IN idNV INT)
BEGIN
    DECLARE v_count INT;
    DECLARE idNQL INT;

    SELECT COUNT(ID_NV), ID_NQL INTO v_count, idNQL
    FROM NHANVIEN
    WHERE ID_NV = idNV;

    IF v_count > 0 THEN
        IF idNV = idNQL THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Không thể xóa quản lý';
        ELSE
            DELETE FROM CTNK WHERE ID_NK IN (SELECT ID_NK FROM PHIEUNK WHERE ID_NV = idNV);
            DELETE FROM CTXK WHERE ID_XK IN (SELECT ID_XK FROM PHIEUXK WHERE ID_NV = idNV);
            DELETE FROM PHIEUNK WHERE ID_NV = idNV;
            DELETE FROM PHIEUXK WHERE ID_NV = idNV;
            DELETE FROM NHANVIEN WHERE ID_NV = idNV;
        END IF;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Nhân viên không tồn tại';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE KH_XoaKH(IN idKH INT)
BEGIN
    DECLARE v_count INT;

    SELECT COUNT(*) INTO v_count
    FROM KHACHHANG
    WHERE ID_KH = idKH;

    IF v_count > 0 THEN
        DELETE FROM CTHD WHERE ID_HoaDon IN (SELECT ID_HoaDon FROM HOADON WHERE ID_KH = idKH);
        DELETE FROM HOADON WHERE ID_KH = idKH;
        DELETE FROM KHACHHANG WHERE ID_KH = idKH;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Khách hàng không tồn tại';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE KH_XemTT(IN idKH INT)
BEGIN
    DECLARE v_TenKH VARCHAR(255);
    DECLARE v_Ngaythamgia DATE;
    DECLARE v_Doanhso DECIMAL(10, 2);
    DECLARE v_Diemtichluy INT;
    DECLARE v_ID_ND INT;

    SELECT TenKH, Ngaythamgia, Doanhso, Diemtichluy, ID_ND INTO v_TenKH, v_Ngaythamgia, v_Doanhso, v_Diemtichluy, v_ID_ND
    FROM KHACHHANG
    WHERE ID_KH = idKH;

    SELECT CONCAT('Mã khách hàng: ', idKH) AS ThongTin;
    SELECT CONCAT('Tên khách hàng: ', v_TenKH) AS ThongTin;
    SELECT CONCAT('Ngày tham gia: ', DATE_FORMAT(v_Ngaythamgia, '%d-%m-%Y')) AS ThongTin;
    SELECT CONCAT('Doanh số: ', v_Doanhso) AS ThongTin;
    SELECT CONCAT('Điểm tích lũy: ', v_Diemtichluy) AS ThongTin;
    SELECT CONCAT('Mã người dùng: ', v_ID_ND) AS ThongTin;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE NV_XemTT(IN idNV INT)
BEGIN
    DECLARE v_TenNV VARCHAR(255);
    DECLARE v_NgayVL DATE;
    DECLARE v_SDT VARCHAR(15);
    DECLARE v_Chucvu VARCHAR(100);
    DECLARE v_ID_NQL INT;

    SELECT TenNV, NgayVL, SDT, Chucvu, ID_NQL INTO v_TenNV, v_NgayVL, v_SDT, v_Chucvu, v_ID_NQL
    FROM NHANVIEN
    WHERE ID_NV = idNV;

    SELECT CONCAT('Mã nhân viên: ', idNV) AS ThongTin;
    SELECT CONCAT('Tên nhân viên: ', v_TenNV) AS ThongTin;
    SELECT CONCAT('Ngày vào làm: ', DATE_FORMAT(v_NgayVL, '%d-%m-%Y')) AS ThongTin;
    SELECT CONCAT('Số điện thoại: ', v_SDT) AS ThongTin;
    SELECT CONCAT('Chức vụ: ', v_Chucvu) AS ThongTin;
    SELECT CONCAT('Mã người quản lý: ', v_ID_NQL) AS ThongTin;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE DS_HoaDon_tuAdenB(IN fromA DATE, IN toB DATE)
BEGIN
    DECLARE done INT DEFAULT 0;

    -- Declare variables to store the data fetched by the cursor
    DECLARE ID_HoaDon INT;
    DECLARE ID_KH INT;
    DECLARE ID_BAN INT;
    DECLARE NGAYHD DATE;
    DECLARE TIENMONAN DECIMAL(10, 2);
    DECLARE TIENGIAM DECIMAL(10, 2);
    DECLARE TONGTIEN DECIMAL(10, 2);
    DECLARE TRANGTHAI VARCHAR(255);

    -- Declare the cursor
    DECLARE cur CURSOR FOR 
        SELECT ID_HoaDon, ID_KH, ID_BAN, NGAYHD, TIENMONAN, TIENGIAM, TONGTIEN, TRANGTHAI
        FROM HOADON
        WHERE NGAYHD BETWEEN fromA AND toB;

    -- Declare a handler for end of data
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    -- Open the cursor
    OPEN cur;

    -- Start looping through the cursor data
    read_loop: LOOP
        FETCH cur INTO ID_HoaDon, ID_KH, ID_BAN, NGAYHD, TIENMONAN, TIENGIAM, TONGTIEN, TRANGTHAI;
        
        -- If no more rows, exit the loop
        IF done THEN
            LEAVE read_loop;
        END IF;

        -- Display information
        SELECT CONCAT('Mã hóa đơn: ', ID_HoaDon) AS ThongTin;
        SELECT CONCAT('Mã khách hàng: ', ID_KH) AS ThongTin;
        SELECT CONCAT('Mã bàn: ', ID_BAN) AS ThongTin;
        SELECT CONCAT('Ngày hóa đơn: ', DATE_FORMAT(NGAYHD, '%d-%m-%Y')) AS ThongTin;
        SELECT CONCAT('Tiền món ăn: ', TIENMONAN) AS ThongTin;
        SELECT CONCAT('Tiền giảm: ', TIENGIAM) AS ThongTin;
        SELECT CONCAT('Tổng tiền: ', TONGTIEN) AS ThongTin;
        SELECT CONCAT('Trạng thái: ', TRANGTHAI) AS ThongTin;
    END LOOP;

    -- Close the cursor
    CLOSE cur;
END //
DELIMITER ;


DELIMITER //
CREATE PROCEDURE Voucher_GiamSL(IN code VARCHAR(50))
BEGIN
    DECLARE v_count INT;

    SELECT COUNT(*) INTO v_count FROM Voucher WHERE Code_Voucher = code;

    IF v_count > 0 THEN
        UPDATE Voucher SET SoLuong = SoLuong - 1 WHERE Code_Voucher = code;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Voucher không tồn tại';
    END IF;
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE KH_TruDTL(IN ID INT, IN diemdoi INT)
BEGIN
    DECLARE v_count INT;

    SELECT COUNT(*) INTO v_count FROM KHACHHANG WHERE ID_KH = ID;

    IF v_count > 0 THEN
        UPDATE KHACHHANG SET Diemtichluy = Diemtichluy - diemdoi WHERE ID_KH = ID;
    ELSE
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Khách hàng không tồn tại';
    END IF;
END //
DELIMITER ;

– Funtion
DELIMITER //
CREATE FUNCTION DoanhThuHD_theoNgay(ngHD DATE)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE v_Doanhthu DECIMAL(10, 2);
    
    SELECT IFNULL(SUM(Tongtien), 0) INTO v_Doanhthu
    FROM HOADON 
    WHERE NGAYHD = ngHD;

    RETURN v_Doanhthu;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION ChiPhiNK_theoNgay(ngNK DATE)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE v_Chiphi DECIMAL(10, 2);
    
    SELECT IFNULL(SUM(Tongtien), 0) INTO v_Chiphi
    FROM PHIEUNK 
    WHERE NGAYNK = ngNK;

    RETURN v_Chiphi;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION DoanhsoTB_TOPxKH(x INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE v_avg DECIMAL(10, 2);

    SELECT AVG(Doanhso) INTO v_avg
    FROM (
        SELECT Doanhso 
        FROM KHACHHANG
        ORDER BY Doanhso DESC
        LIMIT x
    ) AS TopKH;

    RETURN v_avg;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION SL_KH_Moi(thang INT, nam INT, trigiaHD DECIMAL(10, 2))
RETURNS INT
DETERMINISTIC
BEGIN
    DECLARE v_count INT;

    SELECT COUNT(ID_KH) INTO v_count
    FROM KHACHHANG
    WHERE MONTH(Ngaythamgia) = thang 
      AND YEAR(Ngaythamgia) = nam
      AND EXISTS (
          SELECT 1
          FROM HOADON
          WHERE HOADON.ID_KH = KHACHHANG.ID_KH 
            AND TONGTIEN > trigiaHD
      );

    RETURN v_count;
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION CTHD_Tinhtiengiam(Tongtien DECIMAL(10, 2), Code VARCHAR(50))
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE Tiengiam DECIMAL(10, 2);
    DECLARE v_Phantram DECIMAL(5, 2);

    SELECT Phantram INTO v_Phantram
    FROM Voucher
    WHERE Code_Voucher = Code;

    SET Tiengiam = ROUND(Tongtien * v_Phantram / 100, 2);

    RETURN Tiengiam;
END //
DELIMITER ;

-- Them data
-- Thêm data cho Bảng NguoiDung
-- Nhân viên
INSERT INTO NguoiDung(ID_ND, Email, MatKhau, Trangthai, Vaitro) VALUES (100, 'NVHoangViet@gmail.com', '123', 'Verified', 'Quan Ly');
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
INSERT INTO NhanVien(ID_NV, TenNV, NgayVL, SDT, Chucvu, ID_ND, ID_NQL, Tinhtrang) VALUES (100, 'Nguyen Hoang Viet', '2023-05-10', '0848044725', 'Quan ly', 100, 100, 'Dang lam viec');
INSERT INTO NhanVien(ID_NV, TenNV, NgayVL, SDT, Chucvu, ID_ND, ID_NQL, Tinhtrang) VALUES (101, 'Nguyen Hoang Phuc', '2023-05-20', '0838033334', 'Tiep tan', 101, 100, 'Dang lam viec');
INSERT INTO NhanVien(ID_NV, TenNV, NgayVL, SDT, Chucvu, ID_ND, ID_NQL, Tinhtrang) VALUES (102, 'Le Thi Anh Hong', '2023-05-19', '0838033234', 'Kho', 102, 100, 'Dang lam viec');
INSERT INTO NhanVien(ID_NV, TenNV, NgayVL, SDT, Chucvu, ID_ND, ID_NQL, Tinhtrang) VALUES (103, 'Ho Quang Dinh', '2023-05-19', '0838033234', 'Tiep tan', 103, 100, 'Dang lam viec');
-- Không có tài khoản
INSERT INTO NhanVien(ID_NV, TenNV, NgayVL, SDT, Chucvu, ID_NQL, Tinhtrang) VALUES (104, 'Ha Thao Duong', '2023-05-10', '0838033232', 'Phuc vu', 100, 'Dang lam viec');
INSERT INTO NhanVien(ID_NV, TenNV, NgayVL, SDT, Chucvu, ID_NQL, Tinhtrang) VALUES (105, 'Nguyen Quoc Thinh', '2023-05-11', '0838033734', 'Phuc vu', 100, 'Dang lam viec');
INSERT INTO NhanVien(ID_NV, TenNV, NgayVL, SDT, Chucvu, ID_NQL, Tinhtrang) VALUES (106, 'Truong Tan Hieu', '2023-05-12', '0838033834', 'Phuc vu', 100, 'Dang lam viec');
INSERT INTO NhanVien(ID_NV, TenNV, NgayVL, SDT, Chucvu, ID_NQL, Tinhtrang) VALUES (107, 'Nguyen Thai Bao', '2023-05-10', '0838093234', 'Phuc vu', 100, 'Dang lam viec');
INSERT INTO NhanVien(ID_NV, TenNV, NgayVL, SDT, Chucvu, ID_NQL, Tinhtrang) VALUES (108, 'Tran Nhat Khang', '2023-05-11', '0838133234', 'Thu ngan', 100, 'Dang lam viec');
INSERT INTO NhanVien(ID_NV, TenNV, NgayVL, SDT, Chucvu, ID_NQL, Tinhtrang) VALUES (109, 'Nguyen Ngoc Luong', '2023-05-12', '0834033234', 'Bep', 100, 'Dang lam viec');

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

-- Pisces
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (84, 'Ca Hoi Ngam Tuong', 289000, 'Pisces', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (85, 'Ca Ngu Ngam Tuong', 289000, 'Pisces', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (86, 'IKURA:Trung ca hoi', 189000, 'Pisces', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (87, 'KARIN:Sashimi Ca Ngu', 149000, 'Pisces', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (88, 'KEIKO:Sashimi Ca Hoi', 199000, 'Pisces', 'Dang kinh doanh');
INSERT INTO MonAn (ID_MonAn, TenMon, Dongia, Loai, TrangThai) VALUES (89, 'CHIYO:Sashimi Bung Ca Hoi', 219000, 'Pisces', 'Dang kinh doanh');

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

-- Tầng 3
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (124, 'Ban T3.1', 'Tang 3', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (125, 'Ban T3.2', 'Tang 3', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (126, 'Ban T3.3', 'Tang 3', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (127, 'Ban T3.4', 'Tang 3', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (128, 'Ban T3.5', 'Tang 3', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (129, 'Ban T3.6', 'Tang 3', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (130, 'Ban T3.7', 'Tang 3', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (131, 'Ban T3.8', 'Tang 3', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (132, 'Ban T3.9', 'Tang 3', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (133, 'Ban T3.10', 'Tang 3', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (134, 'Ban T3.11', 'Tang 3', 'Con trong');
INSERT INTO Ban (ID_Ban, TenBan, Vitri, Trangthai) VALUES (135, 'Ban T3.12', 'Tang 3', 'Con trong');

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

select * from Voucher;

-- Insert từng dòng vào bảng HoaDon
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai) VALUES (101, 100, 100, '2023-01-10', 0, 0, 'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai) VALUES (102, 104, 102, '2023-01-15', 0, 0, 'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai) VALUES (103, 105, 103, '2023-01-20', 0, 0, 'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai) VALUES (104, 101, 101, '2023-02-13', 0, 0, 'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai) VALUES (105, 103, 120, '2023-02-12', 0, 0, 'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai) VALUES (106, 104, 100, '2023-03-16', 0, 0, 'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai) VALUES (107, 107, 103, '2023-03-20', 0, 0, 'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai) VALUES (108, 108, 101, '2023-04-10', 0, 0, 'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai) VALUES (109, 100, 100, '2023-04-20', 0, 0, 'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai) VALUES (110, 103, 101, '2023-05-05', 0, 0, 'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai) VALUES (111, 106, 102, '2023-05-10', 0, 0, 'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai) VALUES (112, 108, 103, '2023-05-15', 0, 0, 'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai) VALUES (113, 106, 102, '2023-05-20', 0, 0, 'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai) VALUES (114, 108, 103, '2023-06-05', 0, 0, 'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai) VALUES (115, 109, 104, '2023-06-07', 0, 0, 'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai) VALUES (116, 100, 105, '2023-06-07', 0, 0, 'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai) VALUES (117, 106, 106, '2023-06-10', 0, 0, 'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai) VALUES (118, 102, 106, '2023-02-10', 0, 0, 'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai) VALUES (119, 103, 106, '2023-02-12', 0, 0, 'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai) VALUES (120, 104, 106, '2023-04-10', 0, 0, 'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai) VALUES (121, 105, 106, '2023-04-12', 0, 0, 'Chua thanh toan');
INSERT INTO HoaDon(ID_HoaDon, ID_KH, ID_Ban, NgayHD, TienMonAn, TienGiam, Trangthai) VALUES (122, 107, 106, '2023-05-12', 0, 0, 'Chua thanh toan');

-- Insert từng dòng vào bảng CTHD
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (101, 1, 2);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (101, 3, 1);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (101, 10, 3);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (102, 1, 2);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (102, 2, 1);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (102, 4, 2);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (103, 12, 2);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (104, 30, 3);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (104, 59, 4);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (105, 28, 1);
INSERT INTO CTHD(ID_HoaDon, ID_MonAn, SoLuong) VALUES (105, 88, 2);
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


-- Thêm dữ liệu cho bảng NguyenLieu
INSERT INTO NguyenLieu(ID_NL, TenNL, Dongia, Donvitinh) VALUES (100, 'Thit ga', 40000, 'kg');
INSERT INTO NguyenLieu(ID_NL, TenNL, Dongia, Donvitinh) VALUES (101, 'Thit heo', 50000, 'kg');
INSERT INTO NguyenLieu(ID_NL, TenNL, Dongia, Donvitinh) VALUES (102, 'Thit bo', 80000, 'kg');
INSERT INTO NguyenLieu(ID_NL, TenNL, Dongia, Donvitinh) VALUES (103, 'Tom', 100000, 'kg');
INSERT INTO NguyenLieu(ID_NL, TenNL, Dongia, Donvitinh) VALUES (104, 'Ca hoi', 500000, 'kg');
INSERT INTO NguyenLieu(ID_NL, TenNL, Dongia, Donvitinh) VALUES (105, 'Gao', 40000, 'kg');
INSERT INTO NguyenLieu(ID_NL, TenNL, Dongia, Donvitinh) VALUES (106, 'Sua tuoi', 40000, 'l');
INSERT INTO NguyenLieu(ID_NL, TenNL, Dongia, Donvitinh) VALUES (107, 'Bot mi', 20000, 'kg');
INSERT INTO NguyenLieu(ID_NL, TenNL, Dongia, Donvitinh) VALUES (108, 'Dau ca hoi', 1000000, 'l');
INSERT INTO NguyenLieu(ID_NL, TenNL, Dongia, Donvitinh) VALUES (109, 'Dau dau nanh', 150000, 'l');
INSERT INTO NguyenLieu(ID_NL, TenNL, Dongia, Donvitinh) VALUES (110, 'Muoi', 20000, 'kg');
INSERT INTO NguyenLieu(ID_NL, TenNL, Dongia, Donvitinh) VALUES (111, 'Duong', 20000, 'kg');
INSERT INTO NguyenLieu(ID_NL, TenNL, Dongia, Donvitinh) VALUES (112, 'Hanh tay', 50000, 'kg');
INSERT INTO NguyenLieu(ID_NL, TenNL, Dongia, Donvitinh) VALUES (113, 'Toi', 30000, 'kg');
INSERT INTO NguyenLieu(ID_NL, TenNL, Dongia, Donvitinh) VALUES (114, 'Dam', 50000, 'l');
INSERT INTO NguyenLieu(ID_NL, TenNL, Dongia, Donvitinh) VALUES (115, 'Thit de', 130000, 'kg');

-- Thêm dữ liệu cho bảng PhieuNK
INSERT INTO PhieuNK(ID_NK, ID_NV, NgayNK) VALUES (100, 102, '2023-01-10');
INSERT INTO PhieuNK(ID_NK, ID_NV, NgayNK) VALUES (101, 102, '2023-02-11');
INSERT INTO PhieuNK(ID_NK, ID_NV, NgayNK) VALUES (102, 102, '2023-02-12');
INSERT INTO PhieuNK(ID_NK, ID_NV, NgayNK) VALUES (103, 102, '2023-03-12');
INSERT INTO PhieuNK(ID_NK, ID_NV, NgayNK) VALUES (104, 102, '2023-03-15');
INSERT INTO PhieuNK(ID_NK, ID_NV, NgayNK) VALUES (105, 102, '2023-04-12');
INSERT INTO PhieuNK(ID_NK, ID_NV, NgayNK) VALUES (106, 102, '2023-04-15');
INSERT INTO PhieuNK(ID_NK, ID_NV, NgayNK) VALUES (107, 102, '2023-05-12');
INSERT INTO PhieuNK(ID_NK, ID_NV, NgayNK) VALUES (108, 102, '2023-05-15');
INSERT INTO PhieuNK(ID_NK, ID_NV, NgayNK) VALUES (109, 102, '2023-06-05');
INSERT INTO PhieuNK(ID_NK, ID_NV, NgayNK) VALUES (110, 102, '2023-06-07');

-- Thêm dữ liệu cho bảng CTNK
INSERT INTO CTNK(ID_NK, ID_NL, SoLuong) VALUES (100, 100, 10);
INSERT INTO CTNK(ID_NK, ID_NL, SoLuong) VALUES (100, 101, 20);
INSERT INTO CTNK(ID_NK, ID_NL, SoLuong) VALUES (100, 102, 15);
INSERT INTO CTNK(ID_NK, ID_NL, SoLuong) VALUES (101, 101, 10);
INSERT INTO CTNK(ID_NK, ID_NL, SoLuong) VALUES (101, 103, 20);
INSERT INTO CTNK(ID_NK, ID_NL, SoLuong) VALUES (101, 104, 10);
INSERT INTO CTNK(ID_NK, ID_NL, SoLuong) VALUES (101, 105, 10);
INSERT INTO CTNK(ID_NK, ID_NL, SoLuong) VALUES (101, 106, 20);
INSERT INTO CTNK(ID_NK, ID_NL, SoLuong) VALUES (101, 107, 5);
INSERT INTO CTNK(ID_NK, ID_NL, SoLuong) VALUES (101, 108, 5);
-- (Tiếp tục như trên cho các dòng còn lại...)

-- Thêm dữ liệu cho bảng PhieuXK
INSERT INTO PhieuXK(ID_XK, ID_NV, NgayXK) VALUES (100, 102, '2023-01-10');
INSERT INTO PhieuXK(ID_XK, ID_NV, NgayXK) VALUES (101, 102, '2023-02-11');
INSERT INTO PhieuXK(ID_XK, ID_NV, NgayXK) VALUES (102, 102, '2023-03-12');
INSERT INTO PhieuXK(ID_XK, ID_NV, NgayXK) VALUES (103, 102, '2023-03-13');
INSERT INTO PhieuXK(ID_XK, ID_NV, NgayXK) VALUES (104, 102, '2023-04-12');
INSERT INTO PhieuXK(ID_XK, ID_NV, NgayXK) VALUES (105, 102, '2023-04-13');
INSERT INTO PhieuXK(ID_XK, ID_NV, NgayXK) VALUES (106, 102, '2023-05-12');
INSERT INTO PhieuXK(ID_XK, ID_NV, NgayXK) VALUES (107, 102, '2023-05-15');
INSERT INTO PhieuXK(ID_XK, ID_NV, NgayXK) VALUES (108, 102, '2023-05-20');
INSERT INTO PhieuXK(ID_XK, ID_NV, NgayXK) VALUES (109, 102, '2023-06-05');
INSERT INTO PhieuXK(ID_XK, ID_NV, NgayXK) VALUES (110, 102, '2023-06-10');

-- Thêm dữ liệu cho bảng CTXK
INSERT INTO CTXK(ID_XK, ID_NL, SoLuong) VALUES (100, 100, 5);
INSERT INTO CTXK(ID_XK, ID_NL, SoLuong) VALUES (100, 101, 5);
INSERT INTO CTXK(ID_XK, ID_NL, SoLuong) VALUES (100, 102, 5);
INSERT INTO CTXK(ID_XK, ID_NL, SoLuong) VALUES (101, 101, 7);
INSERT INTO CTXK(ID_XK, ID_NL, SoLuong) VALUES (101, 103, 10);
INSERT INTO CTXK(ID_XK, ID_NL, SoLuong) VALUES (101, 104, 5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (101,105,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (101,106,10);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (102,109,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (102,110,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (102,112,10);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (102,113,8);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (102,114,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (103,114,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (103,104,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (104,101,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (104,112,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (105,113,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (105,102,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (106,103,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (106,114,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (107,105,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (107,106,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (108,115,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (108,110,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (109,110,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (109,112,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (110,113,5);
INSERT INTO CTXK(ID_XK,ID_NL,SoLuong) VALUES (110,114,5);

