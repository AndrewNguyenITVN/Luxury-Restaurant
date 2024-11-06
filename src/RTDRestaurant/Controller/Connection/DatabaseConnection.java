
package RTDRestaurant.Controller.Connection;

import java.sql.Connection;
import java.sql.SQLException;
import java.sql.DriverManager;

// Kết nối tới DataBase của hệ thống

public class DatabaseConnection {

    private static DatabaseConnection instance;
    private Connection connection;

    public static DatabaseConnection getInstance() {
        if (instance == null) {
            instance = new DatabaseConnection();
        }
        return instance;
    }

    private DatabaseConnection() {

    }
    //Thực hiện kết nối tới Database
//    public void connectToDatabase() throws SQLException {
//        final String url = "jdbc:oracle:thin:@localhost:1521:orcl";
//        final String username = "Doan";
//        final String password = "123";
//        connection = DriverManager.getConnection(url, username, password);
//    }
    public void connectToDatabase() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver"); // Sử dụng MySQL Connector/J
            String url = "jdbc:mysql://127.0.0.1:3306/java_mysql?useSSL=false&allowPublicKeyRetrieval=true"; // Cập nhật URL nếu cần
            String username = "user1"; // Tên người dùng
            String password = "123"; // Mật khẩu
            
            connection = DriverManager.getConnection(url, username, password);
            System.out.println("Kết nối đến cơ sở dữ liệu thành công!");
        } catch (Exception ex) {
            System.out.println("Không thể kết nối đến cơ sở dữ liệu.");
            ex.printStackTrace();
        }
    }

 
    public Connection getConnection() {
        return connection;
    }
    
    public void setConnection(Connection connection) {
        this.connection = connection;
    }
}

