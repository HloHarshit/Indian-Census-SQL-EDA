use indiancensus;

-- Calculate the Total Population of India
SELECT SUM(Population) as 'Total Population of India' FROM data2;  

-- Retrieve the data for Jharkhand and Bihar
SELECT * FROM data1 WHERE STATE IN ('Jharkhand', 'Bihar');

-- Calculate the Average Growth by each State
SELECT State, ROUND(AVG(Growth)*100,2) AS Avg_Growth FROM data1 GROUP BY state;

-- Calculate the Average Sex Ratio by each State
SELECT State, ROUND(AVG(Sex_Ratio),2) AS Avg_Sex_Ratio FROM data1 GROUP BY state;

-- Calculate the Average Literacy by each State and sort it from highest to lowest
SELECT State, ROUND(AVG(Literacy),2) AS Avg_Literacy FROM data1 GROUP BY State ORDER BY Avg_Literacy DESC;

-- Reterive the Top 3 and Bottom 3 States in Literacy Rate
(SELECT State, District, Literacy FROM data1 ORDER BY Literacy DESC LIMIT 3)
UNION ALL
(SELECT State, District, Literacy FROM data1 ORDER BY Literacy ASC LIMIT 3);

-- Calculate the Male and Female Ratio by each State

/* Formulas to find Male and Female Raio:
Population = Males + Females ----------(equation 1)
	Males = Population - Females
    Females = Population - Males
    
Sex Ratio = Females/Males ----------(equation 2)
	Females = Sex Ratio * Males
    Population - Males = Sex Ratio * Males
    Population = (Sex Ratio * Males) + Males
    Population = Males(Sex Ratio + 1)
    Males = Population/(Sex Ratio + 1) ----------(equation 3)
    
    Females = Population - Population/(Sex Ratio + 1)
    Females = Population(1-1/(Sex Ratio + 1))
    Females = (Population * Sex Ratio)/(Sex Ratio + 1) --------(equation 4) */
 
 
 SELECT State, SUM(Population) AS 'Total Population', ROUND(SUM(Population/(Sex_Ratio + 1))) AS 'Total Males', ROUND(SUM((Population * Sex_Ratio)/(Sex_Ratio + 1))) AS 'Total Females'
 FROM 
	(SELECT a.District, a.State, a.Sex_Ratio/1000 AS Sex_Ratio, b.Population
	FROM data1 a
	INNER JOIN data2 b ON a.District = b.District) c
GROUP BY State;

-- Caluclate the Total Literate and Illiterate people

/* Literaccy Ratio = Total Literate People/Population -------------(equation 1)
		Total Literate People = Literacy Ratio * Population ----------(equation 2)
        Total Illiterate People = (1-Literacy Rato) * Population --------(equation 3) */

SELECT State, ROUND(SUM(Literacy_Ratio*Population),2) AS 'Total Literate People', ROUND(SUM((1-Literacy_Ratio)*Population),2) AS 'Total Illiterate People'
FROM
	(SELECT a.District, a.State, a.Literacy/100 AS Literacy_Ratio, b.Population
	FROM data1 a
	INNER JOIN data2 b ON a.District = b.District) c
GROUP BY State;

-- Calculate the Previous Census Population
/* Population = Previous Census Population + (Growth * Previous Census Population) ---------(equation 1)
   Population = Previous Census Population (1 + Growth)
   Previous Census Population = Population/(1 + Growth) ----------(equation 2) */
   
SELECT  SUM(Previous_Census_Population) AS Previous_Census_Population, SUM(Current_Census_Population) AS Current_Census_Population FROM
	(SELECT State, ROUND(SUM(Population/(1+Growth)),2) AS Previous_Census_Population, SUM(Population) AS Current_Census_Population
	FROM
		(SELECT a.District, a.State, a.Growth/100 AS Growth, b.Population
		FROM data1 a
		INNER JOIN data2 b ON a.District = b.District) c
	GROUP BY State) d;
    
    
-- Calculate the Area_km2 vs Population
SELECT g.Total_Area/g.Previous_Census_Population AS Previous_Area, g.Total_Area/g.Current_Census_Population AS Current_Area
FROM 
(SELECT q.*, k.Total_Area
FROM
(SELECT '1' AS Keyy, n.*
FROM
	(SELECT SUM(Previous_Census_Population) AS Previous_Census_Population, SUM(Current_Census_Population) AS Current_Census_Population
	FROM
		(SELECT State, ROUND(SUM(Population/(1+Growth)),2) AS Previous_Census_Population, SUM(Population) AS Current_Census_Population
		FROM
			(SELECT a.State, a.District, a.Growth/100 as Growth, b.Population
			FROM data1 a
			INNER JOIN data2 b ON a.District = b.District) c
		GROUP BY State) d) n) q
INNER JOIN 
(SELECT '1' AS Keyy, r.*
FROM (SELECT SUM(Area_km2) AS Total_Area from data2) r) k ON q.Keyy = k.Keyy) g;


-- Retrieve Top 3 States with the highest litereacy rate using window function

SELECT a.* FROM
(SELECT State, District, Literacy, RANK() OVER(PARTITION BY State ORDER BY Literacy DESC) AS Rnk
FROM data1) a
WHERE a.rnk IN (1,2,3)
ORDER BY State;
