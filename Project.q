//the below code should be on server process q -p 5000
show books: ("I*  I  *** I";enlist ",") 0: hsym `$"lms_project/All_Book_Data.csv";
show students: ("I**  **I";enlist ",") 0: hsym `$"lms_project/Student Data.csv";
students:`sid`name`college`email`mobile xcol students;
books:`bid`bname`pages`price`prog_lang`concept`copies xcol books;
`sid xkey `students;
`bid xkey `books;

//Define issue table when project is setup for the first time otherwise load the csv file
issue: ([id:`int$()]bookid:`books$();studentid:`students$();dateofissue:`date$(); dateofreturn:`date$());
//issue: ("IIIDD";enlist ";") 0: hsym `$"Project/Student Data.csv";
//1!`issue 

//takes book id,student id as arg and issue the particular book issued to that student
issueBookToStudent:{[bookid;stuid]
    x:count issue;
    y:books[bookid;`copies];
    z:value exec count id by studentid from issue where studentid=stuid,dateofreturn=0Nd;
    if[y<1;:`$"No More Copies Available for this book"];
    if[z[0]>=5;:`$"Student already has 5 books"];
    update copies-1 from `books where bid=bookid;
    `issue upsert ((x+1);bookid;stuid;.z.D;0Nd);
    `$"Book Issued"
 }; 

//takes book id,student id as arg and return the particular book issued to that student 
returnBook:{[bid;stuid]
    //get the book to be returned
    x:exec id,dateofissue from issue where bookid=bid,studentid=stuid,dateofreturn=0Nd;
    if[0=count x`id;:`$"No record found for student"];
    noOfdays:x[`dateofissue;0]-.z.D;
    if[noOfdays>15;update Fine:Fine+(10*noOfdays-15) from `students where sid=stuid];
    update dateofreturn:.z.D from `issue where id=x[`id;0];
    update copies+1 from `books where bid=bid;
    `$"Book Returned"
 }
//takes student ID and return books issued to that student
getBooksIssued:{[sid]
    x:select Books:bookid.bname,CountOfBooks:count(i) by Name:studentid.name from issue where studentid=sid,dateofreturn=0Nd;
    if[0=count x;:`$"No Books issued to this student"];
    x
 };

saveTheTables:{
    `:lms_project/All_Book_Data.csv 0: csv 0: books;
    (hsym `$"lms_project/Student Data.csv") 0:csv 0: students;
    `:lms_project/Books_Issued.csv 0: csv 0: issue;
    `$"Tables Saved"
 }

 
//Create Another Q process, we'll call it a client Process which will make request to Server to issue,return,fetch books to/for the student
// h:hopen `::5000 open handle to server process
// h (`issueBookToStudent;2;2)
// h (`returnBook;2;2)
// h (`getBooksIssued;2)
// neg[h] (`saveTheTables;::)