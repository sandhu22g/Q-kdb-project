# Q-kdb-project
Library Management System using q kdb+

Simple beginner project to get familiar with q kdb+.This project will help us understand various concepts of q kdb like: reading the files from disk, IPC, creating
functions, explicit return, updating the tables. With a built-in programming and query language, analytics are performed “in database” without the need to move data over
a network or to another computation or analytics layer. Kdb+ performs computations, aggregations, and filters in the database.

load this Project.q script into q session.It will be considered as server process and will listen at port::5000
Change the paths accordingly to load/save tables.
Start another client process and open handle to server and then the request for below functionalities can be made:
1. issueBookToStudent - takes 2 args book id and student id
2. returnBook - takes 2 args book id and student id
3. getBooksIssued - takes 1 arg student id
4. saveTheTables - takes no argument and simply save the changes in tables to disk.
