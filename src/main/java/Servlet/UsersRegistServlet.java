package Servlet;

import java.io.IOException;

import Model.UsersRegistLogic;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class UsersRegistServlet
 */
public class UsersRegistServlet extends HttpServlet {
	private static final long serialVersionUID = 1L;
       
    /**
     * @see HttpServlet#HttpServlet()
     */
    public UsersRegistServlet() {
        super();
        // TODO Auto-generated constructor stub
    }

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		// 1. Logicを呼び出して最新のIDを取得する
         UsersRegistLogic logic = new UsersRegistLogic(); 
         int latestId = logic.getLatestId();
        
        // 2. 取得したIDを request にセットしてJSPに渡す
        request.setAttribute("latestId", latestId);
        
        // 3. 登録画面（JSP）へフォワード
        RequestDispatcher dispatcher = request.getRequestDispatcher("WEB-INF/jsp/UsersRegist.jsp");
        dispatcher.forward(request, response);		
		
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
