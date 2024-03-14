package com.project;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

@WebServlet("/ValidateStudentTable")
public class ValidateStudentTable extends HttpServlet {
    private static final long serialVersionUID = 1L;
    Connection con = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;

    static String url = "jdbc:mysql://localhost:3306/feedbackproject";
    static String dbUsername = "root";
    static String dbPassword = "gopika@123";

    public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        PrintWriter pw = response.getWriter();
        try {
            con = DriverManager.getConnection(url, dbUsername, dbPassword);

            // Student information from request parameters
            String id = request.getParameter("registerNo");
            String acc = request.getParameter("acc_year");
            String year = request.getParameter("year");
            String branch = request.getParameter("branch");
            String sem = request.getParameter("semester");
            String cycle = request.getParameter("cycle");
            String sec = request.getParameter("section");
            String ss=year+"_"+sem+"_"+branch+"_"+sec;
            String stname = "s" + year + sem + id;

            // Check for existing student table
            java.sql.DatabaseMetaData metadata = con.getMetaData();
            rs = metadata.getTables(null, null, stname, null);
            if (rs.next()) {
                request.getRequestDispatcher("completed.html").forward(request, response);
                return; // Exit if table already exists
            }

            // Create a session or retrieve the existing one
            HttpSession session = request.getSession(true);

            // Query to retrieve faculty information based on section and academic year
            String facultyQuery = "SELECT fid, sub, fname FROM faculty WHERE sec = ? AND acc_year = ?";
            PreparedStatement facultyStmt = con.prepareStatement(facultyQuery);
            facultyStmt.setString(1, ss);
            facultyStmt.setString(2, acc);
            ResultSet facultyResult = facultyStmt.executeQuery();

            List<FacultyInfo> facultyInfoList = new ArrayList<>(); // List to store faculty information
            while (facultyResult.next()) {
                int fid = facultyResult.getInt("fid");
                String sub = facultyResult.getString("sub");
                String fname = facultyResult.getString("fname");
                facultyInfoList.add(new FacultyInfo(fid, sub, fname)); // Add faculty info to list
            }

            // Create student table if not exists
            String createStudentTableSQL = "CREATE TABLE IF NOT EXISTS " + stname + " (" +
                    "`fid` INT ," +
                    "`sub` TEXT," +
                    "`sec` TEXT," +
                    "`fname` TEXT" +

                    ") ENGINE=InnoDB DEFAULT CHARSET=latin1;";
            java.sql.Statement createStudentTableStmt = con.createStatement();
            createStudentTableStmt.executeUpdate(createStudentTableSQL);

            // Insert |faculty information into student table
            for (FacultyInfo faculty : facultyInfoList) {
                String query = "INSERT INTO " + stname + " VALUES(?, ?, ?, ?)";
                PreparedStatement inserting = con.prepareStatement(query);
                inserting.setInt(1, faculty.getFid());
                inserting.setString(2, faculty.getSub());
                inserting.setString(3, ss);
                inserting.setString(4, faculty.getFname());
                inserting.executeUpdate();
            }

            // Store information in the session
            session.setAttribute("facultyInfoList", facultyInfoList);
            session.setAttribute("cycle", cycle);
            System.out.println(cycle);
            session.setAttribute("acc_year", acc);
            System.out.println(acc);
            session.setAttribute("sec", sec);
            System.out.println(sec);
            session.setAttribute("id", id);
            System.out.println(id);
            session.setAttribute("currentIndex", 0); // Initial faculty index for iteration

            // Forward request to question.jsp
            RequestDispatcher dd = request.getRequestDispatcher("question.jsp");
            dd.forward(request, response);	 
}catch(Exception e) {
	e.printStackTrace();
}
    }
}
