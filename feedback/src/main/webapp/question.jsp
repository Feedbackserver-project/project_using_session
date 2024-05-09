

<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Feedback Form</title>

  <style>
    body {
      font-family: "Times New Roman", Times, serif;
      font-size: 20px;
      margin: 0;
      display: flex;
      justify-content: center;
      align-items: center;
      background-color: #f4f4f4;
    }

    .page-container {
      background-color: #ffffff;
      padding: 20px;
      border-radius: 25px;
      box-shadow: 0 2px 4px rgba(0, 0, 0, 0.5);
      width: 100%;
      max-width: 800px;
      border-color: black;
    }

    .page-container1 {
      padding: 20px;
      border-radius: 25px;
      width: 100%;
      max-width: 1000px;
      border-color: black;
    }

    #header {
      text-align: center;
    }

    .header {
      text-align: center;
      margin-bottom: 30px;
    }

    .divider {
      height: 2px;
      background-color: #ccc;
      margin: 20px 0;
    }

    .question {
      margin-bottom: 10px;
    }

    .question-text {
      font-weight: bold;
      margin-bottom: 10px;
    }

    .options {
      display: flex;
    }

    label {
      margin-right: 10px;
    }

    .submit {
      background-color: #4CAF50; /* Green */
      border: none;
      color: black;
      padding: 15px 32px;
      text-align: center;
      text-decoration: none;
      display: inline-block;
      font-size: 16px;
    }
  </style>


</head>

<body>

  <div>
    <div class="page-container1">
      <img src="vvitlogo.jpg">
    </div>

    <div class="page-container">
      <div class="header">
        <h2>STUDENT FEEDBACK ON FACULTY</h2>
      </div>

      <div class="divider"></div>

      <hr>

      
      
      <h4>Academic Year: <%= session.getAttribute("academicyear") %> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; Cycle: <%= session.getAttribute("cycle") %></h4>

      <%String[] facultyInfo = (String[]) session.getAttribute("facultyinfo");%>
       
       <h4>Faculty Name: <%= facultyInfo[2] %></h4>
       <h5>Subject: <%= facultyInfo[1] %></h5>  
      <div class="divider"></div>

      <form id="questionsForm" action="SubmitFeedback" method="post">
        <%
    String[] questions = {
        "Student knowledge:",
        "Effectively utilizes Black Board:",
        "Clear and audible voice:",
        "Completes the syllabus in the stipulated time:",
        "Provides information beyond the syllabus:",
        "Comes regularly to the classes:",
        "Shows interest in clearing student doubts:",
        "Uses audio video when needed:",
        "Conducts assignments/tutorials regularly:",
        "Returns the valued test papers/records in time:",
        "Encourages the originality and creativity:",
        "Maintains students discipline:",
        "Communication Skills:",
        "Comes unprepared for the class:",
        "Shows bias and discrimination among students:"
    };
%>

<%
    for (int i = 0; i < questions.length; i++) {
%>
<div class="question">
    <p class="question-text">Q<%= i + 1 %>. <%= questions[i] %></p><br>
    <div class="options">
        <label><input type="radio" name="q<%= i + 1 %>" value="5" required> Excellent</label>
        <label><input type="radio" name="q<%= i + 1 %>" value="4" required> Very Good</label>
        <label><input type="radio" name="q<%= i + 1 %>" value="3"required> Good</label>
        <label><input type="radio" name="q<%= i + 1 %>" value="2"required> Average</label>
        <label><input type="radio" name="q<%= i + 1 %>" value="1"required> Bad</label>
    </div>
</div><br>
<%
    }
%>
<% String rollno =(String)session.getAttribute("rollno");
String[] fids = (String[])session.getAttribute("fids");
int fCounter = 0; // Initialize to a default value
        String fCounterParam = request.getParameter("fCounter");
        if (fCounterParam != null && !fCounterParam.isEmpty()) {
            fCounter = Integer.parseInt(fCounterParam);
        }

  %>         
<%-- Check if facultyInfoList is not empty --%>
        <input type="hidden" name="rollno" value="<%= rollno %>">
		<input type="hidden" name="fCounter" value="<%= fCounter %>">
        <center>
        <input type="submit" value="submit" " style=" font-size:20px; padding: 10px 15px; background-color:cornflowerblue; border-radius:10px">
        </center>
        
        
       

      </form>
    </div>
  </div>

</body>
</html>
