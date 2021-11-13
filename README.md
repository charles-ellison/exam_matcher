# README

This application exposes an endpoint that allows users to be matched with an existing exam.

With the server running locally, a post request can be sent as show below:
```
post 'localhost:3000/api/v1/user_exams
    body: {
	"first_name": "bob",
	"last_name": "jones",
	"phone_number": "5554443333",
	"college_id": 1,
	"exam_id": 1,
	"start_time": "2021-11-13 08:11:54.772413 -0600"
}
```
All of the request body params are required and the ids must match their corresponding records in the db for a successful response. The seed file will add a college, an exam_window, and an exam to the db.

* Ruby version: 2.7.1

* System dependencies: This server uses postgresql

* To run the server:
    - run `bundle`
    - create the database: `rails db:create`
    - run the seed file (optional): `rails db:seed`
    - run the migrations: `rails db:migrate`

* How to run the test suite
    - The test suite can be run with: `rspec`
