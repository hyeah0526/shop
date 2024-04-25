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
		
		// 주문버튼을 누르면 state는 '주문완료'로 들어감
		String sql = "INSERT INTO orders(mail, goods_no, total_amount, total_price, address, State)"
				+ " VALUES (?, ?, ?, ?, ?, '주문완료')";
		
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, cMail);
		stmt.setInt(2, goodsNo);
		stmt.setInt(3, totalAmount);
		stmt.setInt(4, totalPrice);
		stmt.setString(5, address);
		
		System.out.println("orderGoods-> "+stmt);
		
		row = stmt.executeUpdate();
		
		conn.close();
		return row;
	}
	
/* 고객 자신이 주문한 상품을 보여주기 */
	public static ArrayList<HashMap<String, Object>> myOrderOne(String cMail, int startRow, int selectRowInt) throws Exception{
		ArrayList<HashMap<String, Object>> myOrder = new ArrayList<>();
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		String sql ="SELECT * "
				+ " FROM orders "
				+ " WHERE mail = ?"
				+ " ORDER BY orders_no desc LIMIT ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, cMail);
		stmt.setInt(2, startRow);
		stmt.setInt(3, selectRowInt);
		System.out.println("myOrderOne-> "+stmt);
		
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
	
/* OrderList totalRow구하기 :: 페이징*/
	public static int totalOrderListRow() throws Exception{
		int totalOrderListRow = 0;
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		String sql = "SELECT COUNT(*) cnt FROM orders";
		stmt = conn.prepareStatement(sql);
		System.out.println("totalOrderListRow-> "+stmt);
		
		rs = stmt.executeQuery();
		if(rs.next()){
			totalOrderListRow = rs.getInt("cnt");
		}
		
		conn.close();
		return totalOrderListRow;
	}
	
/* myOrderList totalRow구하기 :: 페이징*/
	public static int myOrderListRow(String cMail) throws Exception{
		int myOrderListRow = 0;
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		// 고객 본인아이디의 주문목록 총 개수가져오기
		String sql = "SELECT COUNT(*) cnt FROM orders WHERE mail = ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, cMail);
		System.out.println("totalOrderListRow-> "+stmt);
		
		rs = stmt.executeQuery();
		if(rs.next()){
			myOrderListRow = rs.getInt("cnt");
		}
		
		conn.close();
		return myOrderListRow;
	}
	
/* 고객이 주문한 모든 상품 보여주기select - emp페이지 */
	public static ArrayList<HashMap<String, Object>> selectOrderList(int startRow, int selectRowInt) throws Exception{
		ArrayList<HashMap<String, Object>> OrderList = new ArrayList<>();
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		String sql = "SELECT o.orders_no ordersNo, o.mail cMail, o.total_price totalPrice, o.total_amount totalAmount,"
				+ " o.state state, o.create_date createDate, g.goods_no goodsNo, g.goods_title goodsTitle, o.address address"
				+ " FROM orders o INNER JOIN goods g"
				+ " ON o.goods_no = g.goods_no" // orders테이블과 goods테이블의 상품번호가 같아야함
				+ " order by o.orders_no desc LIMIT ?, ?"; //페이징 - orders_no가 높은 것(최신순)부터 보여주기
		
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, startRow);
		stmt.setInt(2, selectRowInt);
		System.out.println("selectOrderList-> "+stmt);
		
		rs = stmt.executeQuery();
		
		while(rs.next()) {
			HashMap<String, Object> list = new HashMap<>();
			list.put("ordersNo", rs.getInt("ordersNo"));
			list.put("cMail", rs.getString("cMail"));
			list.put("address", rs.getString("address"));
			list.put("totalPrice", rs.getInt("totalPrice"));
			list.put("totalAmount", rs.getInt("totalAmount"));
			list.put("state", rs.getString("state"));
			list.put("createDate", rs.getString("createDate"));
			list.put("goodsNo", rs.getInt("goodsNo"));
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
		String sql = "UPDATE orders SET state = ?,"
				+ " create_date = create_date,"
				+ " update_date = NOW()"
				+ " WHERE orders_no = ?";
		
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, newState);
		stmt.setInt(2, ordersNo);
		System.out.println("updateStateOrder-> "+stmt);
		
		row = stmt.executeUpdate();
		
		conn.close();
		return row;
	}
	
	
/* 고객이 주문한 상품을 취소하기(주문완료 및 결제완료일때만) update  - customer페이지 */
	public static int updateCancelMyOrders(int ordersNo) throws Exception{
		int row = 0;
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		
		// 고객이 주문을 취소하면 state를 '주문취소'로 변경하고 결제시스템이 끝남
		String sql = "UPDATE orders SET state = ?,"
				+ " create_date = create_date,"
				+ " update_date = NOW()"
				+ " WHERE orders_no = ?";
		
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "주문취소");
		stmt.setInt(2, ordersNo);
		System.out.println("updateCancelMyOrders-> "+stmt);
		
		row = stmt.executeUpdate();
		
		conn.close();
		return row;
	}

}
