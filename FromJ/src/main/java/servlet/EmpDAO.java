package servlet;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.naming.Context;
import javax.naming.InitialContext;
import javax.sql.DataSource;

public class EmpDAO {
	//성, 명을 전달받아서 그 이름에 해당하는 사원정보를 리턴함 
	/*
	 * public Emp getEmpByFirstNLastName(String firstName, String lastName) throws
	 * Exception { Emp emp = new Emp(); Connection conn =
	 * DriverManager.getConnection("jdbc:mysql://localhost:3306/newhr", "root",
	 * "rootroot"); String sql =
	 * "select * from employees where first_name = ? and last_name = ?";
	 * PreparedStatement stmt = conn.prepareStatement(sql); stmt.setString(1,
	 * firstName); stmt.setString(2, lastName); ResultSet rs = stmt.executeQuery();
	 * if(rs.next()) { emp.id = rs.getInt("employee_id"); emp.lastName =
	 * rs.getString("last_name"); emp.salary = rs.getInt("salary"); } return emp; }
	 * 
	 * public static List<Emp> getEmpListByDeptNo(int deptNo) throws Exception {
	 * 
	 * }
	 * 
	 * public static List<Emp> getEmpListByJobId(String jobId) throws Exception {
	 * 
	 * } public static Emp getEmpById(int empId) throws Exception {
	 * 
	 * }
	 */
	
	private static Connection getConnection() throws Exception {
		Context initContext = new InitialContext();
		Context envContext = (Context) initContext.lookup("java:comp/env");
		DataSource dataSource = (DataSource) envContext.lookup("jdbc/mydb");
		Connection connection = dataSource.getConnection();
		return connection;
	}

}
