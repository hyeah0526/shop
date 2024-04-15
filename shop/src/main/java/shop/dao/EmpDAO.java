package shop.dao;

import java.sql.*;
import java.util.*;

// emp 테이블을 CRUD하는 메서드의 컨테이너
public class EmpDAO {

	
/* insertEmp */
	public static int insertEmp(String empId, String empPw, String empName, String empJob) throws Exception {
		int row = 0;
		
		// DB 접근코드
		Connection conn = DBHelper.getConnection();
		
		String sql = "INSERT INTO emp(emp_id, emp_pw, emp_name, emp_job)VALUES(?, ?, ?, ?);";
		PreparedStatement stmt = null;
		ResultSet rs = null;
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, empId);
		stmt.setString(2, empPw);
		stmt.setString(3, empName);
		stmt.setString(4, empJob);
		System.out.println(stmt + " <--insertEmp");
		
		row = stmt.executeUpdate();
		
		conn.close();
		return row;
	}
	
/* emplogin */
	// 반환값이 HashMap<String, Object> loginEmp 이게 되어야함
	// HashMap<String, Object>이 null이면 로그인 실패, 아니면 성공
	// 사용자 입력값 ID와 PW이므로 즉 String 2개 (String empId, String empPw)
	// throws Exception 모든 예외를 처리
	
	// 호출할때 HashMap<String, Object> m = empDAO.empLogin("admin","1234");
	public static HashMap<String, Object> emplogin(String empId, String empPw) throws Exception{
		HashMap<String, Object> resultMap = null;
		
		// DB 접근코드
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		ResultSet rs = null;
		
		String sql = "select emp_id empId, emp_name empName, grade from emp where active='ON' and emp_id=? and emp_pw=password(?)";
		stmt = conn.prepareStatement(sql);
		
		stmt.setString(1, empId); //(String empId, String empPw)가 들어가야하는 것
		stmt.setString(2, empPw);
		System.out.println(stmt);
		
		rs = stmt.executeQuery();
		
		if(rs.next()) { //로그인이 성공
			resultMap = new HashMap<String, Object>();
			resultMap.put("empId", rs.getString("empId"));
			resultMap.put("empName", rs.getString("empName"));
			resultMap.put("grade", rs.getInt("grade"));
		}
		
		// if문에 안걸렸다면 로그인 실패이므로 resultMap은 null이 return됨
		
		conn.close();
		return resultMap;
	}
	
/* selectEmpList 사원목록 전체 출력 (empList.jsp) */
	public static ArrayList<HashMap<String, Object>> selectEmpList(String empSearch, int startRow, int selectRowInt) 
																										throws Exception{
		ArrayList<HashMap<String, Object>> resultMap = null;
		
		Connection conn = DBHelper.getConnection();
		PreparedStatement stmt = null;
		ResultSet rs = null; 
		String sql = "select emp_id empId, emp_name empName, emp_job empJob, hire_date hireDate, active from emp where emp_name like ? order by hire_date desc limit ?, ?";
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+empSearch+"%");
		stmt.setInt(2, startRow);
		stmt.setInt(3, selectRowInt);
		
		rs = stmt.executeQuery(); 
		
		// 특수한 형태의 자료구조(RDBMS:mariadb)
		// -> API사용(JDBC API)하여 자료구조(ResultSet) 취득 
		// -> 일반화된 자료구조(ArrayList<HashMap>)로 변경
		// -> 모델 취득
		resultMap = new ArrayList<HashMap<String, Object>>();
		while(rs.next()){
			HashMap<String, Object> m = new HashMap<String, Object>(); 
			m.put("empId", rs.getString("empId"));
			m.put("empName", rs.getString("empName"));
			m.put("empJob", rs.getString("empJob"));
			m.put("hireDate", rs.getString("hireDate"));
			m.put("active", rs.getString("active"));
			
			//그리고 그걸 List에 넣어주기
			resultMap.add(m);
		}
		return resultMap;
	}
	
/* empListPaging 사원전체목록페이징(empList.jsp) */
	public static int empListPaging(String empSearch) throws Exception{
		int totalRow = 0;
		
		Connection conn = DBHelper.getConnection();
		String sql = "select count(*) cnt from emp where emp_name like ?";
		PreparedStatement stmt = null;
		ResultSet rs = null; 
		stmt = conn.prepareStatement(sql);
		stmt.setString(1, "%"+empSearch+"%");
		rs = stmt.executeQuery();
		
		System.out.println("empListPaging DAO--> "+stmt);
		
		if(rs.next()){
			totalRow = rs.getInt("cnt");
		}
		return totalRow;
	}
}
