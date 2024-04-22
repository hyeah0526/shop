package shop.dao;

import java.sql.*;
import java.util.*;

public class CustomerDAO {
	
/* modifyCustomerAction.jsp 고객 비밀번호 수정 */
	public static int updateCustomer(String cOldPw, String cNewPw, String cMail) throws Exception{
		int row = 0;
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		
		String sql = "UPDATE customer SET c_pw = PASSWORD(?) WHERE c_mail = ? AND c_pw = PASSWORD(?)";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, cNewPw);
		stmt.setString(2, cMail);
		stmt.setString(3, cOldPw);
		System.out.println(stmt+"수정성공");
		
		row = stmt.executeUpdate();
		
		conn.close();
		return row;
	}
	
/* deleteCustomerAction.jsp 고객탈퇴 */
	public static int deleteCustomer(String cMail, String cPw) throws Exception{
		int row = 0;
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		
		String sql = "DELETE FROM customer WHERE c_mail = ? AND c_pw = PASSWORD(?)";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, cMail);
		stmt.setString(2, cPw);
		
		row = stmt.executeUpdate();
		
		conn.close();
		return row;
	}

/* customerLogin 고객로그인 */
	public static HashMap<String, Object> customerLogin(String cMail, String cPw) throws Exception{
		HashMap<String, Object> resultMap = null;
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		String sql = "SELECT c_mail Cmail, c_name cName FROM customer WHERE c_mail = ? AND c_pw = PASSWORD(?)";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, cMail);
		stmt.setString(2, cPw);
		
		rs = stmt.executeQuery();
		System.out.println("customerLogin DAO--> "+stmt);
		
		if(rs.next()) {
			resultMap = new HashMap<>();
			resultMap.put("cMail", rs.getString("Cmail"));
			resultMap.put("cName", rs.getString("cName"));
		}
		
		conn.close();
		return resultMap;
	}
	
/* checkId 회원가입 이메일 중복체크 (checkIdAction.jsp) */
	public static int checkId(String chkMail) throws Exception{
		int row = 0;
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		ResultSet rs = null; 
		
		String sql = "SELECT c_mail Cmail FROM customer WHERE c_mail = ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, chkMail);
		
		rs = stmt.executeQuery();
		if(rs.next()) {
			row = 1;
		}
		
		conn.close();
		return row;
	}
	
/* login정보 가져오기 */
	public static HashMap<String, String> customerOne(String cMail) throws Exception{
		HashMap<String, String> resultMap = null;
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		ResultSet rs = null; 
		
		String sql = "SELECT c_mail, c_name, c_birth, c_gender, create_date from customer where c_mail = ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, cMail);
		
		rs = stmt.executeQuery();
		
		if(rs.next()) {
			resultMap = new HashMap<String, String>();
			resultMap.put("cMail", rs.getString("c_mail"));
			resultMap.put("cName", rs.getString("c_name"));
			resultMap.put("cBirth", rs.getString("c_birth"));
			resultMap.put("cGender", rs.getString("c_gender"));
			resultMap.put("createDate", rs.getString("create_date"));
		}
		
		conn.close();
		return resultMap;
	}
}
