package shop.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.*;
import java.io.*;
import java.nio.file.*;

public class GoodsDAO {
/* 상품 주문/취소 시 Goods_amount수정하기 */
	public static int updateGoodsAmount(int goodsNo, String orderCxl, int orderAmount) throws Exception{
		int row = 0;
		
		Connection conn = DBHelper.getConnection();
		String sql = "";
		
		if(orderCxl.equals("order")) {
			System.out.print("주문하기 주문한 amount수량을 빼주기");
			sql = "UPDATE goods"
					+ " SET goods_amount = goods_amount + -?"
					+ " WHERE goods_no = ?";
		}else {
			System.out.print("취소하기 주문한 amount수량을 다시 더해주기");
			sql = "UPDATE goods"
					+ " SET goods_amount = goods_amount + ?"
					+ " WHERE goods_no = ?";
		}
		
		PreparedStatement stmt = conn.prepareStatement(sql);
		stmt.setInt(1, orderAmount);
		stmt.setInt(2, goodsNo);
		
		row = stmt.executeUpdate();
		
		conn.close();
		return row;
	}
	
	
/* 상품리스트 가져오기 selectGoodsList */
	public static ArrayList<HashMap<String, Object>> selectGoodsList(
					String category, String nameScrh, int startRow, int selectRowInt) throws Exception{
		ArrayList<HashMap<String, Object>> list = 
				new ArrayList<HashMap<String, Object>>();
		// DB 접근코드
		Connection conn = DBHelper.getConnection();
		// 컨트롤 + 엔터하면 자동으로 줄나눠줌 
		String sql = "SELECT * FROM goods where category LIKE ? and goods_title LIKE ? ORDER BY update_date desc limit ?, ?";
		PreparedStatement stmt = null;
		ResultSet rs = null; 
		
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+category+"%");
		stmt.setString(2, "%"+nameScrh+"%");
		stmt.setInt(3, startRow);
		stmt.setInt(4, selectRowInt);
		
		System.out.println("selectGoodsList-->" + stmt);
		
		
		
		rs = stmt.executeQuery();
		
		System.out.println(selectRowInt+" <--selectRowInt DAO");
		System.out.println(startRow+" <--startRow DAO");
		
		while(rs.next()){
			HashMap<String, Object> m2 = new HashMap<String, Object>();
			m2.put("goodsNo", rs.getInt("goods_no"));
			m2.put("category", rs.getString("category"));
			m2.put("empId", rs.getString("emp_id"));
			m2.put("goodsTitle", rs.getString("goods_title"));
			m2.put("goodsContent", rs.getString("goods_content"));
			m2.put("goodsPrice", rs.getInt("goods_price"));
			m2.put("goodsAmount", rs.getInt("goods_amount"));
			m2.put("updateDate", rs.getString("update_date"));
			m2.put("filename", rs.getString("filename"));
			list.add(m2);
		}
		
		conn.close();
		return list;
	}
	
	
/* 카테고리 리스트 가져오기 selectCategoryList */
	public static ArrayList<HashMap<String, Object>> selectCategoryList() throws Exception{
		ArrayList<HashMap<String, Object>> resultMap = null;
		// DB 접근코드
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		String sql ="SELECT category, COUNT(*) cnt FROM goods GROUP BY category ORDER BY category asc";
		stmt = conn.prepareStatement(sql);
		System.out.println("selectCategoryList-->" + stmt);
		
		rs = stmt.executeQuery();
		
		resultMap = new ArrayList<HashMap<String, Object>>();
		while(rs.next()){
			HashMap<String, Object> m = new HashMap<String, Object>();
			m.put("category", rs.getString("category"));
			m.put("cnt", rs.getInt("cnt"));
			resultMap.add(m);
		}
		
		conn.close();
		return resultMap;
	}
	
/* 상품목록 페이징 selectGoodsCnt */
	public static ArrayList<HashMap<String, Integer>> selectGoodsCnt(
					String category, String nameScrh, int totalRow, int selectRowInt) throws Exception{
		
		ArrayList<HashMap<String, Integer>> resultMap = new ArrayList<HashMap<String, Integer>>();
		
		Connection conn = DBHelper.getConnection();
		String sql = "select count(*) cnt from goods where category like ? and goods_title LIKE ?";
		PreparedStatement stmt = null;
		ResultSet rs = null; 
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+category+"%");
		stmt.setString(2, "%"+nameScrh+"%");
		
		System.out.println("selectGoodsCnt-->" + stmt);
		
		rs = stmt.executeQuery();
		
		if(rs.next()){
			totalRow = rs.getInt("cnt");
		}
			
		int lastPage = totalRow / selectRowInt;
		if(totalRow % selectRowInt != 0){
			lastPage = lastPage+1;
		}
		
		HashMap<String, Integer> m = new HashMap<String, Integer>();
		m.put("totalRow", totalRow);
		m.put("lastPage", lastPage);
		resultMap.add(m);
		
		conn.close();
		return resultMap;
	}
	
/* selectCategory 전체 카테고리 종류 출력(addGoodsForm) */
	public static ArrayList<String> selectCategory() throws Exception{
		ArrayList<String> resultMap = new ArrayList<String>();
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		ResultSet rs = null; 

		String sql ="SELECT category FROM category";
		stmt = conn.prepareStatement(sql);
		rs = stmt.executeQuery();
		
		while(rs.next()) {
			resultMap.add(rs.getString("category"));
		}
		System.out.println("selectCategory--> "+resultMap);
		
		return resultMap;
	}
	
/* insertGoods 상품등록하기(addGoodsAction.jsp) */
	public static int insertGoods(
			String category, String empId, String goodsTitle, String fileName, String goodsContent, int goodsPrice, int goodsAmount) throws Exception{
		
		int row = 0;
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		
		String sql = "INSERT INTO goods(category, emp_id, goods_title, filename, goods_content, goods_price, goods_amount)VALUES(?, ?, ?, ?, ?, ?, ?)";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, category);
		stmt.setString(2, empId);
		stmt.setString(3, goodsTitle);
		stmt.setString(4, fileName);
		stmt.setString(5, goodsContent);
		stmt.setInt(6, goodsPrice);
		stmt.setInt(7, goodsAmount);
		row = stmt.executeUpdate();
		System.out.println("insertGoods--> "+stmt);
		
		conn.close();
		return row;
	}

	/* goodsOne 상품상세보기 (goodsOne.jsp) */
	public static ArrayList<HashMap<String, Object>> goodsOne(int goodsNo) throws Exception{
		
		ArrayList<HashMap<String, Object>> resultMap = new ArrayList<HashMap<String, Object>>();
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		ResultSet rs = null; 
		String sql = "select * from goods WHERE goods_no = ?";
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, goodsNo);
		System.out.println("goodsOne--> "+stmt);
		rs = stmt.executeQuery();
		
		while(rs.next()){
			HashMap<String, Object> goodsOne = new HashMap<>();
			goodsOne.put("goodsNo", rs.getInt("goods_no"));
			goodsOne.put("category", rs.getString("category"));
			goodsOne.put("empId", rs.getString("emp_id"));
			goodsOne.put("goodsTitle", rs.getString("goods_title"));
			goodsOne.put("filename", rs.getString("filename"));
			goodsOne.put("goodsContent", rs.getString("goods_content"));
			goodsOne.put("goodsPrice", rs.getInt("goods_price"));
			goodsOne.put("goodsAmount", rs.getInt("goods_amount"));
			goodsOne.put("updateDate", rs.getString("update_date"));
			goodsOne.put("createDate", rs.getString("create_date"));
			resultMap.add(goodsOne);
		}
		
		conn.close();
		return resultMap;
	}
	
/* modifyGoods 상품수정하기 (ModifyGoodsAction.jsp) */
	public static int modifyGoods(int goodsNo, String empId, String goodsTitle, String newImg, String goodsContent, 
					int goodsPrice, int goodsAmount) throws Exception{
		
		int row = 0;
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		String sql = "UPDATE goods SET emp_id = ?, goods_title = ?, filename = ?, goods_content = ?, goods_price = ?, goods_amount = ? WHERE goods_no = ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, empId);
		stmt.setString(2, goodsTitle);
		stmt.setString(3, newImg);
		stmt.setString(4, goodsContent);
		stmt.setInt(5, goodsPrice);
		stmt.setInt(6, goodsAmount);
		stmt.setInt(7, goodsNo);
		
		row = stmt.executeUpdate();
		
		conn.close();
		return row;
	}
	
/* deleteGoods 상품삭제 (removeGoodsAction.jsp) */
	public static int deleteGoods(int goodsNo) throws Exception {
		int row = 0;
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		String sql = "delete from goods where goods_no = ?";
		
		stmt = conn.prepareStatement(sql);
		stmt.setInt(1, goodsNo);
		System.out.println("deleteGoods DAO--> "+stmt);
		
		row = stmt.executeUpdate();
		
		conn.close();
		return row;
	}

}
