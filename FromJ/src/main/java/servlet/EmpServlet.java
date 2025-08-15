package servlet;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;

@WebServlet("/emp/*")
public class EmpServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
	@Override
	public void service(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		//Client가 전송한 데이터 추출 /emp/100 => 100
		String empIdStr = req.getPathInfo();// /emp/100 => /100
		System.out.println("id=" + empIdStr);
		if(empIdStr.startsWith("/")) empIdStr = empIdStr.substring(1);
		Emp emp = null;
		try {
			//emp = EmpDAO.getEmpById(Integer.parseInt(empIdStr));
		} catch(Exception e) {
			
		}
		Gson gson = new Gson();
		String result = gson.toJson(emp);
		System.out.println(result);
		PrintWriter out = res.getWriter();
		out.print(result);
		out.close();
	}

}
