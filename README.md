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

Examples:
Successful response:
<img width="1750" alt="Screen Shot 2021-11-13 at 2 09 10 PM" src="https://user-images.githubusercontent.com/94201613/141658113-f62f3476-509d-43c4-b2a5-b449360521ce.png">


When the user has already been added to the exam:
<img width="1750" alt="Screen Shot 2021-11-13 at 2 09 23 PM" src="https://user-images.githubusercontent.com/94201613/141658103-a85628d5-20fa-442a-a3b8-898c6edaa207.png">

When the first_name is blank:
<img width="1753" alt="Screen Shot 2021-11-13 at 2 10 12 PM" src="https://user-images.githubusercontent.com/94201613/141658138-11a55a9d-ee6f-430f-ad9b-00fef95b2fec.png">

When a parameter is missing:
<img width="1752" alt="Screen Shot 2021-11-13 at 2 10 36 PM" src="https://user-images.githubusercontent.com/94201613/141658151-e9b6e7b5-8e5b-4ef6-a580-61ee58d5f1d7.png">

When the phone_number is invalid:

<img width="1752" alt="Screen Shot 2021-11-13 at 2 10 58 PM" src="https://user-images.githubusercontent.com/94201613/141658165-64fa32d0-49a8-45d7-be0a-915dbe6bcee2.png">

When the college is not found:
<img width="1751" alt="Screen Shot 2021-11-13 at 2 11 19 PM" src="https://user-images.githubusercontent.com/94201613/141658183-ceff8ab2-5230-4c22-a724-d2a9f69ed37b.png">

When the start_time is outside the exam window:
<img width="1748" alt="Screen Shot 2021-11-13 at 2 12 11 PM" src="https://user-images.githubusercontent.com/94201613/141658201-bb4d9bc3-5be6-416f-b8b8-21207604973c.png">


* Ruby version: 2.7.1

* System dependencies: This server uses postgresql

* To run the server:
    - run `bundle`
    - create the database: `rails db:create`
    - run the seed file (optional): `rails db:seed`
    - run the migrations: `rails db:migrate`

* How to run the test suite
    - The test suite can be run with: `rspec`
