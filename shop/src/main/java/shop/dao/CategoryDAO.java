package shop.dao;

import java.sql.Connection;
import java.sql.*;
import java.util.*;

public class CategoryDAO {
	
/* categoryList 전체 카테고리 목록 뿌려주기(CategoryList.jsp) */
	public static ArrayList<HashMap<String, Object>> categoryList() throws Exception{
		
		ArrayList<HashMap<String, Object>> resultMap = null;
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		ResultSet rs = null; 
		
		String sql ="SELECT category, create_date createDate FROM category";
		stmt = conn.prepareStatement(sql);
		rs = stmt.executeQuery();
		System.out.println("categoryList DAO--> "+stmt);
		
		resultMap = new ArrayList<>();
		while(rs.next()){
			HashMap<String, Object> m = new HashMap<>();
			m.put("category", rs.getString("category"));
			m.put("createDate", rs.getString("createDate"));
			resultMap.add(m);
		}
		return resultMap;
	}
	
/* insertCategory 카테고리 추가하기 (CategoryList.jsp) */
	public static int insertCategory(String category) throws Exception{
		int row = 0;
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		String sql = "INSERT INTO category (category) VALUES (?)";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, category);
		
		row = stmt.executeUpdate();
		
		return row;
	}
	
/* deleteCategory 카테고리 삭제 (CategoryList.jsp) */
	public static int deleteCategory(String category) throws Exception{
		int row = 0;
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		String sql = "delete from category where category = ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, category);
		row = stmt.executeUpdate();
		
		return row;
	}

}
