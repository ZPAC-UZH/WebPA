
To *generate excel files* for all the groups:
1) Create an excel file with columns:
  - *Person*: full name of the student (example of entry: "Natalia Obukhova");
  - *Team*: team number 1..N (examples of entry: 1, 15, 10)
2) Save the created file to folder "data/" with the name: "students_groups.xlsx".
3) Open and run "files_generation.Rmd"
  - requires Java
  - requires packages
The generated files will be saved to "generated_files/".

To *calculate the resulting rating*:
1) Create a csv with the following columns:
  - *group_number*: group/team number(examples of entry: 1, 15, 10)
  - *group_size*: the number of students in the group
2) Save the file as "sizes.csv" into the "data/" folder
3) Run the "results_calculation.Rmd"
The results will be saved as "results.xlsx".