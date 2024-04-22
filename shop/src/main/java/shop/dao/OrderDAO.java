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
		
		conn.close();
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
		
		conn.close();
		return myOrder;
	}
	
/* 고객이 주문한 모든 상품 보여주기select - emp페이지 */
	public static ArrayList<HashMap<String, Object>> selectOrderList() throws Exception{
		ArrayList<HashMap<String, Object>> OrderList = new ArrayList<>();
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		String sql = "SELECT o.orders_no ordersNo, o.mail cMail, o.total_price totalPrice, o.total_amount totalAmount,"
				+ " o.state state, o.create_date createDate, g.goods_no goodsNo, g.goods_title goodsTitle"
				+ " FROM orders o INNER JOIN goods g"
				+ " ON o.goods_no = g.goods_no";
		
		stmt = conn.prepareStatement(sql);
		rs = stmt.executeQuery();
		
		while(rs.next()) {
			HashMap<String, Object> list = new HashMap<>();
			list.put("ordersNo", rs.getInt("ordersNo"));
			list.put("cMail", rs.getString("cMail"));
			list.put("totalPrice", rs.getInt("totalPrice"));
			list.put("totalAmount", rs.getInt("totalAmount"));
			list.put("state", rs.getString("state"));
			list.put("createDate", rs.getString("createDate"));
			list.put("goodsNo", rs.getString("goodsNo"));
			list.put("goodsTitle", rs.getString("goodsTitle"));
			
			OrderList.add(list);
		}
		
		conn.close();
		return OrderList;
	}
	
/* 고객이 주문한 상태변경 State update - emp페이지 */
	public static int updateStateOrder(int ordersNo, String oldState, String newState) throws Exception{
		int row = 0;
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		String sql = "UPDATE orders SET state = ?"
				+ "WHERE orders_no = ?";
		
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, newState);
		stmt.setInt(2, ordersNo);
		System.out.println("updateStateOrder-> "+stmt);
		
		row = stmt.executeUpdate();
		
		
		conn.close();
		return row;
	}

}
