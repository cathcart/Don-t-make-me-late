# Don't make me late
An R shiny app to investigate the airline on time statistics database of the U.S. Department of Transportation Bureau of Transportation Statistics.

##Goal
Using the <a href="http://apps.bts.gov/xml/ontimesummarystatistics/src/index.xml">“Airline On Time Statistics”</a> data from the “U.S. Department of Transportation Bureau of Transportation Statistics”:
**find the airline with whom there is the least chance of having a flight delayed.**

##Data
The “Airline On Time Statistics” database tracks a range of departure and arrival statistics for “nonstop scheduled-service flights between points within the United States.” Here we focus on two variables, the **UniqueCarrier** and **ArrDel15** fields. **UniqueCarrier** id is, as the name suggests, a unique carrier id given to every airline operating within the US. The **ArrDel15** variable acts as a binary definition of lateness. If a plane arrives 15 minutes or more beyond its scheduled arrival time it is classified as being late. This makes it easy to compare lateness across the different airlines.

##Data Preprocessing 
Data for several years is scraped from <a href ="http://www.transtats.bts.gov/DL_SelectFields.asp?Table_ID=236&DB_Short_Name=On-Time">Department of Transportation Bureau of Transportation Statistics</a> using ```python get_data.py```, a modified version of <a href="https://github.com/isaacobezo/get_rita">github.com/isaacobezo/get_rita</a>, and pre-processed using ```R -f preprocess.R```.
This converts the **UniqueCarrier** id to a human readable airline name using the lookup table given by the <a href ="http://www.transtats.bts.gov/DL_SelectFields.asp?Table_ID=236&DB_Short_Name=On-Time">Department of Transportation Bureau of Transportation Statistics</a>. This lookup table, `UNIQUE_CARRIERS.csv`, is also downloaded by the `get_data.py` script.
Additionally a fraction on time variable is calculated for each airline for each month. For a given airline for a given month this is the fraction of the total number of flights which are not classified as delayed. These values are then saved to a `.csv` file to allow quick rendering of the data in the shiny app.

##Plots
The app can render three different plots for comparing the fraction of flights arriving on time.
### Fraction on time - monthly plot
<img src="images/monthly.png">
### Fraction on time - timeline plot
<img src="images/timeline.png">
### Fraction on time - airline comparison plot

##Results
The results appear to show that regional airlines such as Hawaiian Airlines and Alaska Airlines have the highest on time fractions of all the airlines. This indicates that it is these airlines with which customers are least likely to face a delayed flight. This is in line with the Department of Transports <a href="https://newsroom.hawaiianairlines.com/releases/dot-rankings">own reports</a> as well as the independent data services company <a href="https://www.alaskaair.com/content/about-us/newsroom/alaska-awards.aspx">FlightStats</a>.
<img src="images/comparison.png">

##Live Demo
A live demo of the app can be found <a href="https://cathcart.shinyapps.io/Dont-make-me-late/">here</a>.
