package shop.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;

public class OrderDAO {
/* 상품 주문시 order 테이블에 저장 */
	public static int orderGoods(
			String cMail, int goodsNo, int totalAmount, int totalPrice, String address) 
																						throws Exception{
		int row = 0;
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		
		String sql = "INSERT INTO orders(mail, goods_no, total_amount, total_price, address, State)"
				+ " VALUES (?, ?, ?, ?, ?, '주문완료')";
		
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, cMail);
		stmt.setInt(2, goodsNo);
		stmt.setInt(3, totalAmount);
		stmt.setInt(4, totalPrice);
		stmt.setString(5, address);
		
		row = stmt.executeUpdate();
		
		return row;
	}
	
/* 고객 자신이 주문한 상품을 보여주기 */
	public static ArrayList<HashMap<String, Object>> myOrderOne(String cMail) throws Exception{
		ArrayList<HashMap<String, Object>> myOrder = new ArrayList<>();
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		String sql ="SELECT * FROM orders WHERE mail = ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, cMail);
		
		rs = stmt.executeQuery();
		
		while(rs.next()) {
			HashMap<String, Object> list = new HashMap<>();
			
			list.put("ordersNo", rs.getInt("orders_no"));
			list.put("goodsNo", rs.getInt("goods_no"));
			list.put("totalAmount", rs.getInt("total_amount"));
			list.put("totalPrice", rs.getInt("total_price"));
			list.put("address", rs.getString("address"));
			list.put("createDate", rs.getString("create_date"));
			list.put("state", rs.getString("state"));
			
			myOrder.add(list);
		}
		return myOrder;
	}

}
