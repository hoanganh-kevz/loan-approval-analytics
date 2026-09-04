SELECT * FROM LoanData

ALTER TABLE dbo.LoanData
ADD RowNumber INT IDENTITY(1,1) NOT NULL;

-- PHÂN TÍCH TỔNG QUAN -- 
-- (1) đếm tổng số hồ sơ, số hồ sơ được duyệt và tỷ lệ duyệt trên toàn bộ bảng LoanData --
SELECT 
	COUNT(*) AS total_applications,
	SUM(CASE WHEN LoanApproved = 1 THEN 1 ELSE 0 END) AS total_approve,
	ROUND(100.0 *
		SUM(CASE WHEN LoanApproved = 1 THEN 1 ELSE 0 END) / 
		COUNT(*), 2) AS approved_rate 
FROM LoanData; 

-- (2) tính RiskScore trung bình, nhỏ nhất, lớn nhất --
SELECT 
	ROUND(MIN(RiskScore), 2) AS min_score,
	ROUND(MAX(RiskScore), 2) AS max_score,
	ROUND(AVG(RiskScore), 2) AS avg_score
FROM LoanData;

-- (3) đếm số hồ sơ theo từng LoanPurpose, sắp xếp giảm dần theo số lượng -- 
SELECT
    LoanPurpose,
    COUNT(*) AS total_applications
FROM LoanData
GROUP BY LoanPurpose
ORDER BY total_applications DESC;

-- TÍN DỤNG CƠ BẢN (LÕI) --
-- (4) so sánh CreditScore trung bình giữa nhóm LoanApproved=1 và LoanApproved=0 --
SELECT 
	LoanApproved,
	ROUND(AVG(CAST(CreditScore AS FLOAT)), 2) AS avg_credit_score
FROM LoanData 
GROUP BY LoanApproved;

-- (5) với các hồ sơ có BankruptcyHistory=1, tính tỷ lệ được duyệt rồi so với nhóm không từng phá sản --
SELECT 
	BankruptcyHistory,
	ROUND(100.0 *
		SUM(CASE WHEN LoanApproved = 1 THEN 1 ELSE 0 END) / 
		COUNT(*), 2) AS approved_rate 
FROM LoanData 
GROUP BY BankruptcyHistory;

-- (6) tìm các hồ sơ có PreviousLoanDefaults=1 nhưng vẫn được duyệt — nếu có, đây là case đáng ngờ cần chú ý -- 
SELECT *
FROM LoanData 
WHERE PreviousLoanDefaults = 1 AND LoanApproved = 1;

-- (7) dùng CASE WHEN chia CreditScore thành 4 khoảng (dưới 580, 580–669, 670–739, từ 740 trở lên), rồi tính tỷ lệ duyệt theo từng khoảng
WITH truyvan AS (
	SELECT 
		LoanApproved,
		CASE 
			WHEN CreditScore < 580 THEN '<580'
            WHEN CreditScore <= 669 THEN '580-669'
            WHEN CreditScore <= 739 THEN '670-739'
            ELSE '740+'
		END AS Credit_Tier 
	FROM LoanData
) 
SELECT 
	Credit_Tier,
	COUNT(*) AS total_applications,
	ROUND(100.0 *
		SUM(CASE WHEN LoanApproved = 1 THEN 1 ELSE 0 END) / 
		COUNT(*), 2) AS approved_rate
FROM truyvan
GROUP BY Credit_Tier
ORDER BY Credit_Tier ASC;

-- SỨC KHỎE TÀI CHÍNH CÁ NHÂN -- 
-- (8) tính DebtToIncomeRatio trung bình theo từng EmploymentStatus --
SELECT
    EmploymentStatus,
    ROUND(AVG(CAST(DebtToIncomeRatio AS FLOAT)), 2) AS avg_DTIR
FROM dbo.LoanData
GROUP BY EmploymentStatus
ORDER BY avg_DTIR DESC;

-- (9) liệt kê 20 hồ sơ có TotalLiabilities lớn hơn TotalAssets (tức NetWorth âm) và RiskScore cao nhất trong nhóm đó --
SELECT TOP 20 *
FROM LoanData
WHERE TotalLiabilities > TotalAssets
ORDER BY RiskScore DESC, TotalLiabilities DESC;

-- (10) so sánh AnnualIncome trung bình giữa nhóm được duyệt và không được duyệt -- 
SELECT 
	LoanApproved,
	ROUND(AVG(CAST(AnnualIncome AS FLOAT)),2) AS avg_AnnualIncome
FROM LoanData 
GROUP BY LoanApproved;

-- ĐẶC ĐIỂM KHOẢN VAY
-- (11) tính tỷ lệ LoanAmount/AnnualIncome trung bình theo từng LoanPurpose -- 
SELECT
    LoanPurpose,
    COUNT(*) AS TotalApplications,
    ROUND(100.0 * AVG(CAST(LoanAmount AS float) / NULLIF(AnnualIncome, 0)), 2) AS DTI
FROM dbo.LoanData
GROUP BY LoanPurpose
ORDER BY DTI DESC;

-- (12) chia RiskScore thành 4 nhóm rồi tính InterestRate trung bình mỗi nhóm, xem có tương quan thuận không -- 
WITH truy_van1 AS(
	SELECT 
		InterestRate, 
		CASE 
			WHEN RiskScore < 25 THEN '0-25'
			WHEN RiskScore <= 50 THEN '26-50'
			WHEN RiskScore <= 75 THEN '51-75'
			ELSE '76-100'
		END AS RiskScore_Tier 
	FROM LoanData
)
SELECT 
	RiskScore_Tier,
	COUNT(*) AS total_applications,
	ROUND(AVG(CAST(InterestRate AS FLOAT)),2) AS avg_InterestRate
FROM truy_van1
GROUP BY RiskScore_Tier
ORDER BY RiskScore_Tier ASC;

-- (13) tính RiskScore trung bình theo từng LoanDuration --
SELECT 
	LoanDuration,
	ROUND(AVG(CAST(RiskScore AS FLOAT)),2) AS avg_RiskkScore
FROM LoanData
GROUP BY LoanDuration
ORDER BY LoanDuration ASC;

-- NHÂN KHẨU HỌC -- 
-- (14) tỷ lệ duyệt theo từng EducationLevel -- 
SELECT 
	EducationLevel, 
	ROUND(100.0 *
		SUM(CASE WHEN LoanApproved = 1 THEN 1 ELSE 0 END) / 
		COUNT(*), 2) AS approved_rate
FROM LoanData
GROUP BY EducationLevel;

-- (15) RiskScore trung bình theo từng khoảng tuổi tự chia (dưới 25, 25–40, 40–60, trên 60) -- 
WITH truy_van2 AS(
	SELECT
		RiskScore, 
		CASE 
			WHEN Age < 25 THEN '<25'
            WHEN Age <= 40 THEN '25-40'
            WHEN Age <= 60 THEN '41-60'
            ELSE '>60' 
		END AS Age_Tier 
	FROM LoanData
)
SELECT 
	Age_Tier,
	ROUND(AVG(CAST(RiskScore AS FLOAT)),2) AS avg_RiskScore,
	COUNT(*) AS total_applications
FROM truy_van2
GROUP BY Age_Tier
ORDER BY Age_Tier;
		
-- NÂNG CAO -- 
-- (16) dùng CASE WHEN gộp RiskScore thành 3 tier Thấp/Trung bình/Cao theo ngưỡng bạn tự chọn, GROUP BY tier để ra số lượng hồ sơ, tỷ lệ duyệt, LoanAmount trung bình và CreditScore trung bình cho mỗi tier --
WITH truy_van3 AS (
	SELECT 
		LoanApproved,
		LoanAmount,
		CreditScore,
		CASE 
			WHEN RiskScore <= 40 THEN 'Thap'
			WHEN RiskScore <= 75 THEN 'Trung binhh'
			ELSE 'Cao'
		END AS RiskScore_Tier
	FROM LoanData
)
SELECT 
	RiskScore_Tier, 
	COUNT(*) AS total_applications,
	ROUND(100.0 *
		SUM(CASE WHEN LoanApproved = 1 THEN 1 ELSE 0 END) / 
		COUNT(*), 2) AS approved_rate,
	ROUND(AVG(CAST(LoanAmount AS FLOAT)), 2) AS avg_LoanAmount,
	ROUND(AVG(CAST(CreditScore AS FLOAT)), 2) AS avg_CreditScore
FROM truy_van3
GROUP BY RiskScore_Tier
ORDER BY RiskScore_Tier;

-- (17) dùng NTILE(4) OVER (ORDER BY RiskScore) để tự động chia toàn bộ hồ sơ thành 4 phần tư rủi ro đều nhau, rồi tính tổng LoanAmount (dư nợ) nằm trong phần tư rủi ro cao nhất -- 
WITH quartiles AS (
    SELECT
        NTILE(4) OVER (ORDER BY RiskScore) AS RiskQuartile,
        LoanAmount
    FROM LoanData
)
SELECT
    RiskQuartile,
    COUNT(*) AS total_applications,
    ROUND(SUM(CAST(LoanAmount AS FLOAT)), 2) AS total_LoanAmount,
    ROUND(AVG(CAST(LoanAmount AS FLOAT)), 2) AS avg_LoanAmount
FROM quartiles
WHERE RiskQuartile = 4
GROUP BY RiskQuartile;