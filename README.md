# 2019.1.20 (Sam)
It will be about one year since this project started, and I am very happy with the progress that was made for this 
application. However, there is still a lot left to be fixed. I will be leaving notes for things that new developers can 
fix within the application such to improve performance and efficiency. Also, I will be leaving some notes on common
issues that I have seen occur recently while testing, such that you can take note of issues that exist.

# Things of Note
Some of the patient data, for whatever reason, is corrupted on Firebase such that no results exist for some 
patients. In this, I have made a temporary fix to keep the application from crashing. The long term fix is 
to A) Fix the patient data on Firebase and B) Change the way that patient data is pushed up to Firebase,
however I no longer have the documentation to access the database.
