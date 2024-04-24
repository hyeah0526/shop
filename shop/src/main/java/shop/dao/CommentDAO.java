package shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;
import java.net.URLEncoder;


public class CommentDAO {
/* 후기작성 가능한지 확인 */
	public static String reviewStateChk(String cMail, int goodsNo) throws Exception{
		String stateChk = "";
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		String sql = "SELECT orders_no ordersNo, state"
				+ " FROM orders"
				+ " WHERE mail = ?"
				+ " AND goods_no = ?";
		
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, cMail);
		stmt.setInt(2, goodsNo);
		System.out.println(stmt + " <--reviewStateChk commetDAO");
		
		rs = stmt.executeQuery();
		
		while(rs.next()) {
			if(rs.getString("state").equals("배송완료")) {
				stateChk = "배송완료";
				
			}else if(rs.getString("state").equals("주문완료") || rs.getString("state").equals("결제완료") || rs.getString("state").equals("배송중")) {
				stateChk = "주문진행중";
				
			}else if(rs.getString("state").equals("리뷰완료")) {
				stateChk = "리뷰완료";
				
			}else {
				stateChk = "구매이력없음";
			}
		}
		
		conn.close();
		return stateChk;
	}
	
/* 후기작성 가능한 ordersNo가져오기 */
	public static ArrayList<HashMap<String, Object>> reviewWriteList(String cMail, int goodsNo) throws Exception{
		ArrayList<HashMap<String, Object>> reviewWriteList = new ArrayList<>();
		
		System.out.println(cMail + " <--cMail reviewWriteList commetDAO");
		System.out.println(goodsNo + " <--goodsNo reviewWriteList commetDAO");
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		// goodsNo로 해당 상품을 주문한 내역 중 '배달완료'만 가져오기 => 리뷰 가능한 것만 담아주기
		String sql = "SELECT orders_no ordersNo, create_date createDate "
				+ " FROM orders"
				+ " WHERE mail = ?"
				+ " AND goods_no = ?"
				+ " AND state = '배송완료'";
		
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, cMail);
		stmt.setInt(2, goodsNo);
		System.out.println(stmt + " <--reviewWriteList commetDAO");
		
		rs = stmt.executeQuery();
		
		while(rs.next()) {
			HashMap<String, Object> r = new HashMap<>();
			r.put("ordersNo", rs.getInt("ordersNo"));
			r.put("createDate", rs.getString("createDate"));
			reviewWriteList.add(r);
		}
		
		conn.close();
		return reviewWriteList;
	}
	
/* 후기목록보여주기 select */
	public static ArrayList<HashMap<String, Object>> selectComment(int goodsNo) throws Exception{
		ArrayList<HashMap<String, Object>> commentList = new ArrayList<HashMap<String,Object>>();
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		String sql = "SELECT c.score, c.content, o.goods_no, s.c_name, c.create_date, o.orders_no, o.create_date"
				+ " FROM comments c"
				+ " INNER JOIN orders o"
				+ " INNER JOIN customer s"
				+ " ON c.orders_no = o.orders_no"
				+ " WHERE o.goods_no = ?"
				+ " AND o.mail = s.c_mail"
				+ " ORDER BY c.create_date DESC";
		  
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, goodsNo);
		
		System.out.println(stmt + " <--selectComment commetDAO");
		rs = stmt.executeQuery();
		
		while(rs.next()) {
			HashMap<String, Object> list = new HashMap<>();
			list.put("score", rs.getInt("c.score"));
			list.put("content", rs.getString("c.content"));
			list.put("orderCreateDate", rs.getString("o.create_date"));
			list.put("cName", rs.getString("s.c_name"));
			list.put("ordersNo", rs.getInt("o.orders_no"));
			list.put("commentCreateDate", rs.getString("c.create_date"));
			
			commentList.add(list);
		}
		
		conn.close();
		return commentList;
	}
	
/* 본인이 작성한 본인 후기 삭제하기 delete */
	public static int deleteMyReview(int ordersNo, String cMail) throws Exception{
		int row = 0;
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		
		String sql = "DELETE c"
				+ " FROM comments c"
				+ " INNER JOIN orders o"
				+ " ON c.orders_no = ?"
				+ " WHERE o.mail = ?";
		
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, ordersNo);
		stmt.setString(2, cMail);
		System.out.println(stmt + " <--deleteMyReview commetDAO");
		
		row = stmt.executeUpdate();
		
		conn.close();
		return row;
	}
	
/* 후기 작성하기 insert */
	public static int insertMyReview(int ordersNo, int score, String content) throws Exception{
		int row = 0;
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		
		String sql = "INSERT INTO comments(orders_no, score, content, create_date) VALUES (?, ?, ?, NOW())";
		
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, ordersNo);
		stmt.setInt(2, score);
		stmt.setString(3, content);
		
		row = stmt.executeUpdate();
		
		conn.close();
		return row;
	}

/* 후기 작성하면 state를 '리뷰완료'로 변경 */
	public static int updateMyReviewState(int ordersNo) throws Exception{
		int row = 0;
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		String sql = "UPDATE orders SET state = '리뷰완료' WHERE orders_no = ?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, ordersNo);
		
		row = stmt.executeUpdate();
		
		conn.close();
		return row;
	}
	
/* 후기 삭제하면 다시 state를 '배송완료'로 변경 */
	public static int deleteMyReviewState(int ordersNo) throws Exception{
		int row = 0;
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		String sql = "UPDATE orders SET state = '배송완료' WHERE orders_no = ?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, ordersNo);
		
		row = stmt.executeUpdate();
		
		conn.close();
		return row;
	}
}
