select * from poetic-glass-456004-g2.modulabs_project.data limit 1;


select count(*) as total_row from poetic-glass-456004-g2.modulabs_project.data;

select count(InvoiceNo) count_InvoiceNo, count(StockCode) count_StockCode, count(Description) count_Description,
      count(Quantity) count_Quantity, count(InvoiceDate) count_InvoiceDate, count(UnitPrice) count_UnitPrice,
      count(CustomerID) count_CustomerID, count(Country) count_Country
from poetic-glass-456004-g2.modulabs_project.data;

-- 컬럼 별 누락된 값의 비율 계산 1
 
SELECT
    'InvoiceNo' AS column_name,
    ROUND(SUM(CASE WHEN InvoiceNo IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS missing_percentage
FROM poetic-glass-456004-g2.modulabs_project.data
union all
SELECT
    'StockCode' AS column_name,
    ROUND(SUM(CASE WHEN StockCode IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS missing_percentage
FROM poetic-glass-456004-g2.modulabs_project.data
union all
SELECT
    'Description' AS column_name,
    ROUND(SUM(CASE WHEN Description IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS missing_percentage
FROM poetic-glass-456004-g2.modulabs_project.data
union all
SELECT
    'Quantity' AS column_name,
    ROUND(SUM(CASE WHEN Quantity IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS missing_percentage
FROM poetic-glass-456004-g2.modulabs_project.data
union all
SELECT
    'UnitPrice' AS column_name,
    ROUND(SUM(CASE WHEN UnitPrice IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS missing_percentage
FROM poetic-glass-456004-g2.modulabs_project.data
union all
SELECT
    'CustomerID' AS column_name,
    ROUND(SUM(CASE WHEN CustomerID IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS missing_percentage
FROM poetic-glass-456004-g2.modulabs_project.data
union all
SELECT
    'Country' AS column_name,
    ROUND(SUM(CASE WHEN Country IS NULL THEN 1 ELSE 0 END) / COUNT(*) * 100, 2) AS missing_percentage
FROM poetic-glass-456004-g2.modulabs_project.data
;

-- 컬럼 별 누락된 값의 비율 계산 2
SELECT column_name, ROUND((total - column_value) / total * 100, 2)
FROM
(
    SELECT 'InvoiceNo' AS column_name, COUNT(InvoiceNo) AS column_value, COUNT(*) AS total FROM poetic-glass-456004-g2.modulabs_project.data UNION ALL
    SELECT 'StockCode' AS column_name, COUNT(StockCode) AS column_value, COUNT(*) AS total FROM poetic-glass-456004-g2.modulabs_project.data UNION ALL
    SELECT 'Description' AS column_name, COUNT(Description) AS column_value, COUNT(*) AS total FROM poetic-glass-456004-g2.modulabs_project.data UNION ALL
    SELECT 'Quantity' AS column_name, COUNT(Quantity) AS column_value, COUNT(*) AS total FROM poetic-glass-456004-g2.modulabs_project.data UNION ALL
    SELECT 'InvoiceDate' AS column_name, COUNT(InvoiceDate) AS column_value, COUNT(*) AS total FROM poetic-glass-456004-g2.modulabs_project.data UNION ALL
    SELECT 'UnitPrice' AS column_name, COUNT(UnitPrice) AS column_value, COUNT(*) AS total FROM poetic-glass-456004-g2.modulabs_project.data UNION ALL
    SELECT 'CustomerID' AS column_name, COUNT(CustomerID) AS column_value, COUNT(*) AS total FROM poetic-glass-456004-g2.modulabs_project.data UNION ALL
    SELECT 'Country' AS column_name, COUNT(Country) AS column_value, COUNT(*) AS total FROM poetic-glass-456004-g2.modulabs_project.data
) AS column_data;

--
select distinct Description
from poetic-glass-456004-g2.modulabs_project.data
where StockCode = '85123A';

-- 결측치 제거
delete from poetic-glass-456004-g2.modulabs_project.data
where Description is null or CustomerID is null;

-- 중복된 행의 수 세기
select count(*) duplicate from poetic-glass-456004-g2.modulabs_project.data
group by InvoiceNo, StockCode, Description, Quantity, InvoiceDate, UnitPrice, CustomerID, Country
having count(*) > 1;

-- 중복값 처리; 중복된 행 지우기 - distinct한 값의 조합으로 테이블 교체
create or replace table poetic-glass-456004-g2.modulabs_project.data as select distinct * from poetic-glass-456004-g2.modulabs_project.data;

----< 오류값 처리 >---

--->> Invoice
-- 고유 invoice 갯수
select count(distinct InvoiceNo) as count_unique_invNo from poetic-glass-456004-g2.modulabs_project.data;
-- 고유 invoice list 100
select distinct InvoiceNo 
from poetic-glass-456004-g2.modulabs_project.data
order by InvoiceNo
limit 100;
-- InvoiceNo가 'C'로 시작하는 행을 필터링 할 수 있는 쿼리문을 작성하기 (100행까지만 출력)
select * from poetic-glass-456004-g2.modulabs_project.data
where InvoiceNo like 'C%' or InvoiceNo like 'c%' 
limit 100; 
-- 구매 건 상태가 Canceled 인 데이터의 비율(%) - 소수점 첫번째 자리까지
select round(sum(case when InvoiceNo like 'C%' then 1 when InvoiceNo like 'c%' then 1 else 0 end) * 100 / count(*), 1) as CAX_rate
from poetic-glass-456004-g2.modulabs_project.data;


--->> Stock 살펴보기
select count(distinct StockCode) uniqueStockCode from poetic-glass-456004-g2.modulabs_project.data;
-- 어떤 제품이 가장 많이 판매되었는지 보기 위하여 StockCode 별 등장 빈도를 출력하기 
select StockCode, count(*) sell_cnt from poetic-glass-456004-g2.modulabs_project.data
group by StockCode
order by sell_cnt desc
limit 10;
-- StockCode의 문자열 내 숫자의 길이 구하기
WITH UniqueStockCodes AS (
  SELECT DISTINCT StockCode
  FROM poetic-glass-456004-g2.modulabs_project.data
)
SELECT
  LENGTH(StockCode) - LENGTH(REGEXP_REPLACE(StockCode, r'[0-9]', '')) AS number_count,
  COUNT(*) AS stock_cnt
FROM UniqueStockCodes
GROUP BY number_count
ORDER BY stock_cnt DESC;

-- 숫자가 0~1개인 값들에는 어떤 코드들이 들어가 있는지 출력하기
SELECT DISTINCT StockCode --, number_count
FROM (
  SELECT StockCode,
    LENGTH(StockCode) - LENGTH(REGEXP_REPLACE(StockCode, r'[0-9]', '')) AS number_count
  FROM poetic-glass-456004-g2.modulabs_project.data
) 
where number_count in (0,1);

-- 숫자가 0~1개인 값들을 가지고 있는 데이터 수는 전체 데이터 수 대비 몇 퍼센트인지 구하기 (소수점 두 번째 자리까지)
SELECT round(cast(countif(number_count in (0,1)) as int64)/ count(*)*100 , 2) rate
FROM (
  SELECT StockCode,
    LENGTH(StockCode) - LENGTH(REGEXP_REPLACE(StockCode, r'[0-9]', '')) AS number_count
  FROM poetic-glass-456004-g2.modulabs_project.data
);

-- 제품과 관련없는 데이터 지우기
delete from poetic-glass-456004-g2.modulabs_project.data
where StockCode In(
  SELECT DISTINCT StockCode
  FROM (
        SELECT StockCode,
          LENGTH(StockCode) - LENGTH(REGEXP_REPLACE(StockCode, r'[0-9]', '')) AS number_count
        FROM poetic-glass-456004-g2.modulabs_project.data
        ) 
  where number_count in (0,1)
);

--->> Description 살펴보기
-- 고유한 description 출현 빈도 상위 30개
select Description,count(*) cnt from poetic-glass-456004-g2.modulabs_project.data 
group by Description 
order by cnt desc
limit 30;

-- 대소문자가 혼합된 desc 확인
SELECT DISTINCT Description
FROM poetic-glass-456004-g2.modulabs_project.data
WHERE REGEXP_CONTAINS(Description, r'[a-z]');

-- 서비스 관련 정보를 포함하는 행들 제거
delete from poetic-glass-456004-g2.modulabs_project.data
where Description like '%High Resolution Image%' or Description like '%Next Day Carriage%';

-- 대문자를 혼합하고 있는 데이터를 대문자로 표준화
CREATE OR REPLACE TABLE poetic-glass-456004-g2.modulabs_project.data AS
SELECT * EXCEPT (Description),
upper(Description) Description FROM poetic-glass-456004-g2.modulabs_project.data;

--->> UnitPrice
--UnitPrice의 최솟값 최댓값 평균
select min(UnitPrice) min, max(UnitPrice) max, avg(UnitPrice) avg
from poetic-glass-456004-g2.modulabs_project.data;
-- 단가가 0원인 거래의 갯수, 구매수량의 최소,최대, 평균
select count(InvoiceNo) cnt, min(Quantity) Qmin, max(Quantity) Qmax, avg(Quantity)Qavg
from poetic-glass-456004-g2.modulabs_project.data
where UnitPrice = 0;
-- 단가가 0원인 거래 지우기
CREATE OR REPLACE TABLE poetic-glass-456004-g2.modulabs_project.data AS 
SELECT *
FROM poetic-glass-456004-g2.modulabs_project.data
WHERE UnitPrice != 0;

----< RFM >----

--->> Recency
-- InvoiceDate 컬럼 자료형 변경 : Date
select date(InvoiceDate) as InvoiceDay, * from poetic-glass-456004-g2.modulabs_project.data;

--가장 최근 구매일자 max()로 찾기
select date(max(InvoiceDate)) most_recent_date
from poetic-glass-456004-g2.modulabs_project.data;

--유저 별로 가장 큰 InvoiceDay를 찾아서 가장 최근 구매일로 저장하기
select distinct CustomerID, max(date(InvoiceDate))over(partition by CustomerID) as InvoiceDay
from poetic-glass-456004-g2.modulabs_project.data
order by CustomerID;

select CustomerID, Date(Max(invoiceDate)) as InvoiceDay
from poetic-glass-456004-g2.modulabs_project.data
group by CustomerID;


-- 가장 최근 일자와 유저별 마지막 구미앨 간의 차이 계산
SELECT
  CustomerID, 
  EXTRACT(DAY FROM MAX(InvoiceDay) OVER () - InvoiceDay) AS recency
FROM (
  SELECT 
    CustomerID,
    MAX(DATE(InvoiceDate)) AS InvoiceDay
  from poetic-glass-456004-g2.modulabs_project.data
  GROUP BY CustomerID
);

-- 테이블 생성 with recency
CREATE OR REPLACE TABLE poetic-glass-456004-g2.modulabs_project.user_r AS
SELECT
  CustomerID, 
  EXTRACT(DAY FROM MAX(InvoiceDay) OVER () - InvoiceDay) AS recency
FROM (
  SELECT 
    CustomerID,
    MAX(DATE(InvoiceDate)) AS InvoiceDay
  from poetic-glass-456004-g2.modulabs_project.data
  GROUP BY CustomerID
);

--->> Frequency
-- 고객마다 고유한 인보이스의 수
select CustomerID, count(InvoiceNo) as purchase_cnt
from poetic-glass-456004-g2.modulabs_project.data
group by CustomerID;

-- 각 고객 별로 구매한 아이템의 총 수량 더하기
select CustomerID, sum(Quantity) item_cnt
from poetic-glass-456004-g2.modulabs_project.data
group by CustomerID;


-- user_rf 테이블 생성 : 전체거래건수계산, 구매한 아이템의 총 수량계산의 결과
CREATE OR REPLACE TABLE poetic-glass-456004-g2.modulabs_project.user_rf AS
WITH purchase_cnt AS ( 
  select CustomerID, count(InvoiceNo) as purchase_cnt
from poetic-glass-456004-g2.modulabs_project.data
group by CustomerID), -- (1) 전체 거래 건수 계산
item_cnt AS (
  select CustomerID, sum(Quantity) item_cnt
from poetic-glass-456004-g2.modulabs_project.data
group by CustomerID)  -- (2) 구매한 아이템 총 수량 계산
SELECT                -- 기존의 user_r에 (1)과 (2)를 통합
  pc.CustomerID,
  pc.purchase_cnt,
  ic.item_cnt,
  ur.recency
FROM purchase_cnt AS pc
JOIN item_cnt AS ic
  ON pc.CustomerID = ic.CustomerID
JOIN poetic-glass-456004-g2.modulabs_project.user_r AS ur
  ON pc.CustomerID = ur.CustomerID;

---> monetary
-- 고객별 총 지출액 계산 (소수점 첫째 자리에서 반올림)
select CustomerID , round(SUM(UnitPrice * Quantity),1) user_total
from poetic-glass-456004-g2.modulabs_project.data
group by CustomerID;

-- 테이블 생성: 고객별 평균 거래 금액 계산
CREATE OR REPLACE TABLE poetic-glass-456004-g2.modulabs_project.user_rfm AS   
SELECT
  rf.CustomerID AS CustomerID,
  rf.purchase_cnt,
  rf.item_cnt,
  rf.recency,
  ut.user_total,
  round(ut.user_total / rf.purchase_cnt,1) user_average
FROM poetic-glass-456004-g2.modulabs_project.user_rf rf
LEFT JOIN (
  SELECT CustomerID , round(SUM(UnitPrice * Quantity),1) user_total
  from poetic-glass-456004-g2.modulabs_project.data
  group by CustomerID ) ut
ON rf.CustomerID = ut.CustomerID;

---> RFM 통합테이블 출력하기

select * from poetic-glass-456004-g2.modulabs_project.user_rfm;

---- << 추가 Feature 추출 >> ----
---> 구매하는 제품의 다양성

CREATE OR REPLACE TABLE poetic-glass-456004-g2.modulabs_project.user_data AS  
WITH unique_products AS (
  SELECT
    CustomerID,
    COUNT(DISTINCT StockCode) AS unique_products
  FROM poetic-glass-456004-g2.modulabs_project.data
  GROUP BY CustomerID
)
SELECT ur.*, up.* EXCEPT (CustomerID)
FROM poetic-glass-456004-g2.modulabs_project.user_rfm AS ur
JOIN unique_products AS up
ON ur.CustomerID = up.CustomerID;

select * from poetic-glass-456004-g2.modulabs_project.user_data;

---> 평균 구매 주기

CREATE OR REPLACE TABLE poetic-glass-456004-g2.modulabs_project.user_data AS 
WITH purchase_intervals AS (
  -- (2) 고객 별 구매와 구매 사이의 평균 소요 일수
  SELECT
    CustomerID,
    CASE WHEN ROUND(AVG(interval_), 2) IS NULL THEN 0 ELSE ROUND(AVG(interval_), 2) END AS average_interval
  FROM (
    -- (1) 구매와 구매 사이에 소요된 일수
    SELECT
      CustomerID,
      DATE_DIFF(InvoiceDate, LAG(InvoiceDate) OVER (PARTITION BY CustomerID ORDER BY InvoiceDate), DAY) AS interval_
    FROM
      poetic-glass-456004-g2.modulabs_project.data
    WHERE CustomerID IS NOT NULL
  )
  GROUP BY CustomerID
)

SELECT u.*, pi.* EXCEPT (CustomerID)
FROM poetic-glass-456004-g2.modulabs_project.user_data AS u
LEFT JOIN purchase_intervals AS pi
ON u.CustomerID = pi.CustomerID;

---> 구매 취소 경향성
CREATE OR REPLACE TABLE poetic-glass-456004-g2.modulabs_project.user_data AS
WITH TransactionInfo AS (
  SELECT
    CustomerID,
    count(InvoiceNo) AS total_transactions,
    countif(InvoiceNo like 'C%' or InvoiceNo like 'c%' ) AS cancel_frequency
  FROM poetic-glass-456004-g2.modulabs_project.data
  group by CustomerID
)

SELECT u.*, t.* EXCEPT(CustomerID), round(cancel_frequency/total_transactions* 100,2) AS cancel_rate
FROM poetic-glass-456004-g2.modulabs_project.user_data AS u
LEFT JOIN TransactionInfo AS t
ON u.CustomerID = t.CustomerID;



-- poetic-glass-456004-g2.modulabs_project.data
-- poetic-glass-456004-g2.modulabs_project.user_rf
-- poetic-glass-456004-g2.modulabs_project.user_rfm
select * from poetic-glass-456004-g2.modulabs_project.data limit 1;
select * from poetic-glass-456004-g2.modulabs_project.user_r ;
select * from poetic-glass-456004-g2.modulabs_project.user_rf;
select * from poetic-glass-456004-g2.modulabs_project.user_rfm limit 1;
select * from poetic-glass-456004-g2.modulabs_project.user_data;