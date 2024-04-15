package shop.dao;

import java.io.FileReader;
import java.sql.*;
import java.util.Properties;

public class DBHelper {
	public static Connection getConnection() throws Exception {
		Class.forName("org.mariadb.jdbc.Driver");
		
		// 깃허브에 id와 pw가 같이 올라가면 안되니까 자기 암호 숨기기!
		// 로컬 PC와 Properties파일 읽어오기
		// FileReadere -> 외부파일을 메모리로 들고올때사용
		FileReader fr = new FileReader("e:\\dev\\auth\\mariadb.properties");
		Properties prop = new Properties();
		prop.load(fr);
		
		//System.out.println(prop.getProperty("id"));
		//System.out.println(prop.getProperty("pw"));
		
		String id = prop.getProperty("id");
		String pw = prop.getProperty("pw");
		
		Connection conn = null;
		conn = DriverManager.getConnection("jdbc:mariadb://127.0.0.1:3306/shop", id, pw);
		
		return conn;
	}
	
	/*
	 * test실행 !!
	 * public static void main(String[] args) throws Exception {
	 * 	DBHelper.getConnection(); 
	 * }
	 * 
	 */
}
// DBHelper.getConnection()를 호출하면 conn을 사용가능함
// 사용법 : Connection conn = DBHelper.getConnection();

