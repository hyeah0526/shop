package shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.HashMap;

public class CommentDAO {
/* 후기작성 Insert */

	
	
/* 후기목록보여주기 select */
	public static ArrayList<HashMap<String, Object>> selectComment(int goodsNo) throws Exception{
		ArrayList<HashMap<String, Object>> commentList = new ArrayList<HashMap<String,Object>>();
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		String sql = "SELECT c.score, c.content, o.goods_no, s.c_name, c.create_date"
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
			
			commentList.add(list);
		}
		return commentList;
	}

}
