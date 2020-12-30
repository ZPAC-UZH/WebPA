# Peer assessment rating template generator and adjustment factor calculation
Written by Natalia Obukhova, Chat Wacharamanotham
Code reviewed by Alexander Eiselmayer

Based on the [WebPA algorithm](http://webpaproject.lboro.ac.uk/academic-guidance/a-worked-example-of-the-scoring-algorithm/).

## Requirements
* R packages
   * `tidyverse`
   * `readxl`
   * `xlsx`
* java (required for the package `xlsx`)

## Generating rating templates for students
1. Create an excel file with columns:
  - *Person*: full name of the student (example of entry: "Natalia Obukhova");
  - *Team*: team number 1..N (examples of entry: 1, 15, 10)
2. Save the created file to folder "input/" with the name: "students_groups.xlsx".
3. Open and run "Rmd/files_generation.Rmd"
  - requires Java
  - requires packages
The generated files will be saved to "output/template_for_students".

## Calculate the adjustment factor based on the ratings

1. You will need the "input/students_groups.xlsx" from above

2. Put the ratings received from students in Excel in `input/submitted_ratings`. Each group should be stored in one folder. For example
   * `input/submitted_ratings/group_01/01.xlsx`
   * `input/submitted_ratings/group_01/02.xlsx`
   * `input/submitted_ratings/group_01/05.xlsx`
   * `input/submitted_ratings/group_02/01.xlsx`

3. Run the "Rmd/results_calculation.Rmd"

4. The grade adjustment factor will be saved as "output/calculated_adjustments.xlsx".
