-- With statement for creating a DetailedResults CTE (Common Table Expression)
-- This CTE aggregates performance details from powerlifting meets in the USA since 2000
WITH DetailedResults AS (
    SELECT 
        m.MeetID,                                   -- Unique identifier for the meet
        m.MeetCountry,                              -- Country where the meet took place
        m.MeetState,                                -- State where the meet took place
        m.MeetTown,                                 -- Town where the meet took place
        m.MeetName,                                 -- Name of the meet
        p.Name,                                     -- Participant's name
        p.Sex,                                      -- Participant's sex
        p.Age,                                      -- Participant's age
        p.Division,                                 -- Competition division of the participant
        EXTRACT(YEAR FROM m.Date) AS MeetYear,      -- Year of the meet
        p.BestSquatKg,                              -- Best squat performance in kilograms
        p.BestBenchKg,                              -- Best bench press performance in kilograms
        p.BestDeadliftKg,                           -- Best deadlift performance in kilograms
        -- Calculates the best squat across all participants in the same division and year
        MAX(p.BestSquatKg) OVER (PARTITION BY p.Division, EXTRACT(YEAR FROM m.Date)) AS DivisionBestSquatKg,
        -- Calculates the best bench press across all participants in the same division and year
        MAX(p.BestBenchKg) OVER (PARTITION BY p.Division, EXTRACT(YEAR FROM m.Date)) AS DivisionBestBenchKg,
        -- Calculates the best deadlift across all participants in the same division and year
        MAX(p.BestDeadliftKg) OVER (PARTITION BY p.Division, EXTRACT(YEAR FROM m.Date)) AS DivisionBestDeadliftKg
    FROM 
        `stable-woods-419122.powerlifting_database.powerlifting` p
    JOIN
        `stable-woods-419122.powerlifting_database.meets` m ON p.MeetID = m.MeetID
    WHERE 
        m.MeetCountry = 'USA' 
        AND EXTRACT(YEAR FROM m.Date) >= 2000
),
-- Subquery for selecting the best squat performances
BestSquat AS (
    SELECT DISTINCT MeetID, MeetCountry, MeetState, MeetTown, MeetName, Name, Age, Sex, BestSquatKg, MeetYear
    FROM DetailedResults
    WHERE BestSquatKg = DivisionBestSquatKg       -- Filters to only include rows where the participant had the best squat in their division
),
-- Subquery for selecting the best bench press performances
BestBench AS (
    SELECT DISTINCT MeetID, MeetCountry, MeetState, MeetTown, MeetName, Name, Age, Sex, BestBenchKg, MeetYear
    FROM DetailedResults
    WHERE BestBenchKg = DivisionBestBenchKg       -- Filters to only include rows where the participant had the best bench press in their division
),
-- Subquery for selecting the best deadlift performances
BestDeadlift AS (
    SELECT DISTINCT MeetID, MeetCountry, MeetState, MeetTown, MeetName, Name, Age, Sex, BestDeadliftKg, MeetYear
    FROM DetailedResults
    WHERE BestDeadliftrstKg = DivisionBeKg        -- Filters to only include rows where the participant had the best deadlift in their division
)
-- Final SELECT statement to combine all best performance records into one unified list
SELECT
    'Best Squat' AS Category,                    -- Marks these records as 'Best Squat' for clarity in the final output
    a.MeetID,
    a.MeetCountry,
    a.MeetState,
    a.MeetTown,
    a.MeetName,
    a.Name,
    a.Age,
    a.Sex,
    a.BestSquatKg AS LiftKg,                     -- Lift performance in kilograms
    a.MeetYear
FROM BestSquat a
UNION ALL
SELECT
    'Best Bench' AS Category,                    -- Marks these records as 'Best Bench'
    b.MeetID,
    b.MeetCountry,
    b.MeetState,
    b.MeetTown,
    b.MeetName,
    b.Name,
    b.Age,
    b.Sex,
    b.BestBenchKg AS LiftKg,
    b.MeetYear
FROM BestBench b
UNION ALL
SELECT
    'Best Deadlift' AS Category,                 -- Marks these records as 'Best Deadlift'
    c.MeetID,
    c.MeetCountry,
    c.MeetState,
    c.MeetTown,
    c.MeetName,
    c.Name,
    c.Age,
    c.Sex,
    c.BestDeadliftKg AS LiftKg,
    c.MeetYear
FROM BestDeadlift c;
