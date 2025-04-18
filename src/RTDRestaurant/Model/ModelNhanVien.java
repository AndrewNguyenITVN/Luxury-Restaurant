
package RTDRestaurant.Model;


public class ModelNhanVien {

    public int getId_NV() {
        return id_NV;
    }

    public void setId_NV(int id_NV) {
        this.id_NV = id_NV;
    }

    public String getTenNV() {
        return tenNV;
    }

    public void setTenNV(String tenNV) {
        this.tenNV = tenNV;
    }

    public String getNgayVL() {
        return ngayVL;
    }

    public void setNgayVL(String ngayVL) {
        this.ngayVL = ngayVL;
    }

    public String getSdt() {
        return sdt;
    }

    public void setSdt(String sdt) {
        this.sdt = sdt;
    }

    public String getChucvu() {
        return chucvu;
    }

    public void setChucvu(String chucvu) {
        this.chucvu = chucvu;
    }


    public String getTinhTrang() {
        return tinhtrang;
    }

    public void setTinhTrang(String tinhTrang) {
        this.tinhtrang = tinhTrang;
    }

    public ModelNhanVien() {

    }

    public ModelNhanVien(int id_NV, String tenNV, String ngayVL, String sdt, String chucvu) {
        this.id_NV = id_NV;
        this.tenNV = tenNV;
        this.ngayVL = ngayVL;
        this.sdt = sdt;
        this.chucvu = chucvu;
    }

    public ModelNhanVien(int id_NV, String tenNV, String ngayVL, String sdt, String chucvu, String tinhTrang) {
        this.id_NV = id_NV;
        this.tenNV = tenNV;
        this.ngayVL = ngayVL;
        this.sdt = sdt;
        this.chucvu = chucvu;
        this.tinhtrang = tinhTrang;
    }
    
    
    private int id_NV;
    private String tenNV;
    private String ngayVL;
    private String sdt;
    private String chucvu;
    private String tinhtrang;
    
}
