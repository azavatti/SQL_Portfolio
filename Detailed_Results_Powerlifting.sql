WITH DetailedResults AS (
    SELECT 
        m.MeetID,
        m.MeetCountry,
        m.MeetState,
        m.MeetTown,
        m.MeetName,
        p.Name,
        p.Sex,
        p.Age,
        p.Division,
        EXTRACT(YEAR FROM m.Date) AS MeetYear,
        p.BestSquatKg,
        p.BestBenchKg,
        p.BestDeadliftKg,
        MAX(p.BestSquatKg) OVER (PARTITION BY p.Division, EXTRACT(YEAR FROM m.Date)) AS DivisionBestSquatKg,
        MAX(p.BestBenchKg) OVER (PARTITION BY p.Division, EXTRACT(YEAR FROM m.Date)) AS DivisionBestBenchKg,
        MAX(p.BestDeadliftKg) OVER (PARTITION BY p.Division, EXTRACT(YEAR FROM m.Date)) AS DivisionBestDeadliftKg
    FROM 
        `stable-woods-419122.powerlifting_database.powerlifting` p
    JOIN
        `stable-woods-419122.powerlifting Database.meets` m ON p.MeetID = m.MeetID
    WHERE 
        m.MeetCountry = 'USA' 
        AND EXTRACT(YEAR FROM m.Date) >= 2000
),
BestSquat AS (
    SELECT DISTINCT MeetID, MeetCountry, MeetState, MeetTown, MeetName, Name, Age, Sex, BestSquatKg, MeetYear
    FROM DetailedResults
    WHERE BestSquatKg = DivisionBestSquatKg
),
BestBench AS (
    SELECT DISTINCT MeetID, MeetCountry, MeetState, MeetTown, MeetName, Name, Age, Sex, BestBenchKg, MeetYear
    FROM DetailedResults
    WHERE BestBenchKg = DivisionBestBenchKg
),
BestDeadlift AS (
    SELECT DISTINCT MeetID, MeetCountry, MeetState, MeetTown, MeetName, Name, Age, Sex, BestDeadliftKg, MeetYear
    FROM DetailedResults
    WHERE BestDeadliftKg = DivisionBestDeadliftKg
)
SELECT
    'Best Squat' AS Category,
    a.MeetID,
    a.MeetCountry,
    a.MeetState,
    a.MeetTown,
    a.MeetName,
    a.Name,
    a.Age,
    a.Sex,
    a.BestSquatKg AS LiftKg,
    a.MeetYear
FROM BestSquat a
UNION ALL
SELECT
    'Best Bench' AS Category,
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
    'Best Deadlift' AS Category,
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
