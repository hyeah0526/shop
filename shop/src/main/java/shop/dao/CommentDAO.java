package shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

import jakarta.security.auth.message.callback.PrivateKeyCallback.Request;

public class CommentDAO {
	
/* 후기목록보여주기 select */
	public static ArrayList<HashMap<String, Object>> selectComment(int goodsNo) throws Exception{
		ArrayList<HashMap<String, Object>> commentList = new ArrayList<HashMap<String,Object>>();
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		String sql = "SELECT c.score, c.content, o.goods_no, s.c_name, c.create_date, o.orders_no"
				+ " FROM comments c"
				+ " INNER JOIN orders o"
				+ " INNER JOIN customer s"
				+ " ON c.orders_no = o.orders_no"
				+ " WHERE o.goods_no = ?"
				+ " AND o.mail = s.c_mail";
		  
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, goodsNo);
		
		rs = stmt.executeQuery();
		
		while(rs.next()) {
			HashMap<String, Object> list = new HashMap<>();
			list.put("score", rs.getInt("c.score"));
			list.put("content", rs.getString("c.content"));
			list.put("createDate", rs.getString("c.create_date"));
			list.put("cName", rs.getString("s.c_name"));
			list.put("ordersNo", rs.getInt("o.orders_no"));
			
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
				+ " ON c.orders_no = o.orders_no"
				+ " WHERE o.mail = ?";
		
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, cMail);
		
		row = stmt.executeUpdate();
		
		conn.close();
		return row;
	}
	
/* 후기작성 ordersNo가져오기 */
	public static int myOrdersNo(int goodsNo, String cMail) throws Exception{
		int myOrdersNo = 0;
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		String sql = "SELECT o.orders_no, g.goods_no, o.mail"
				+ " FROM goods g"
				+ " INNER JOIN orders o"
				+ " ON g.goods_no = o.goods_no"
				+ " WHERE g.goods_no = ?"
				+ " AND o.mail = ?";
		
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, goodsNo);
		stmt.setString(2, cMail);
		
		rs = stmt.executeQuery();
		
		if(rs.next()) {
			myOrdersNo = rs.getInt("o.orders_no");
		}
		System.out.println(myOrdersNo+"왜 안나오냥....");
		
		conn.close();
		return myOrdersNo;
	}
	
/* 후기 작성했는지 확인하기 select - 반환은 String */
	public static String reviewChk(String cMail, int goodsNo) throws Exception{
		String chkReview = "";
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		String sql = "SELECT '작성불가' chk"
				+ " FROM comments c"
				+ " INNER JOIN orders o"
				+ " ON c.orders_no = o.orders_no"
				+ " WHERE o.goods_no = ?"
				+ " AND o.state = '배송완료'"
				+ " AND o.mail = ?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, goodsNo);
		stmt.setString(2, cMail);
		
		rs = stmt.executeQuery();
		
		if(rs.next()) { 
			chkReview = "impossible"; //작성이 불가능해
		}else {
			chkReview = "possible"; //rs가 없으면 작성불가
		}
		System.out.println(chkReview + " <--chkReview reviewChk");
		
		return chkReview;
	}
	
	
/* 후기 작성하기 insert */
	public static int insertMyReview(int ordersNo, int score, String content) throws Exception{
		int row = 0;
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		
		String sql = "INSERT INTO comments(orders_no, score, content) VALUES (?, ?, ?)";
		
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, ordersNo);
		stmt.setInt(2, score);
		stmt.setString(3, content);
		
		row = stmt.executeUpdate();
		
		conn.close();
		return row;
	}

}
