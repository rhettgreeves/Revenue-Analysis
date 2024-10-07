ALTER TABLE services_data
ADD CONSTRAINT fk_branch_id
FOREIGN KEY (branch_id) REFERENCES branch_data(Branch_ID);

SELECT b.Region, SUM(s.total_revenue) AS TotalREvenue
FROM services_data s
JOIN branch_data b ON s.branch_id = b.Branch_ID
GROUP BY b.REgion
ORDER BY TotalRevenue DESC;

SELECT department, SUM(total_revenue) AS TotalRevenue
FROM services_data
GROUP BY department
ORDER BY TotalRevenue DESC;

SELECT client_name, SUM(total_revenue) AS TotalRevenue
FROM services_data
GROUP BY client_name
ORDER BY TotalRevenue DESC;

SELECT SUM(total_revenue) AS TotalRevenue
FROM services_data;

SELECT SUM(hours) AS TotalHours
FROM services_data;

SELECT
	department,
	SUM(total_revenue) AS DepartmentRevenue,
	(SUM(total_revenue) / (SELECT SUM(total_revenue) FROM services_data)) * 100 AS RevenuePercentage
FROM
	services_data
GROUP BY
	department;

WITH MonthlyRevenue AS (
	SELECT 
		FORMAT(service_date, 'yyyy-MM') AS Month,
		SUM(total_revenue) AS Revenue
	FROM
		services_data
	GROUP BY
		FORMAT(service_date, 'yyyy-MM')
),
RevenueComparison AS (
	Select
		Month,
		Revenue,
		LAG(Revenue) OVER (ORDER BY Month) AS PreviousMonthRevenue
	FROM
		MonthlyRevenue
)
SELECT 
	Month,
	Revenue,
	PreviousMonthRevenue,
	((Revenue - PreviousMonthRevenue) / PreviousMonthRevenue) * 100 AS RevenuePercentageIncrease
FROM
	RevenueComparison
WHERE
	PreviousMonthRevenue IS NOT NULL;

