use sys_bazodanowe;

ALTER DATABASE sys_bazodanowe        
ADD FILEGROUP part1;

ALTER DATABASE sys_bazodanowe   
ADD FILEGROUP part2;  

ALTER DATABASE sys_bazodanowe   
ADD FILEGROUP part3;  

ALTER DATABASE sys_bazodanowe   
ADD FILEGROUP part4;   

ALTER DATABASE sys_bazodanowe   
ADD FILE
(  
    NAME = part1,  
    FILENAME = 'C:\test\t1dat1.ndf',  
    SIZE = 5MB,  
    MAXSIZE = 100MB,  
    FILEGROWTH = 3MB  
)  
TO FILEGROUP part1;  

ALTER DATABASE sys_bazodanowe   
ADD FILE   
(  
    NAME = part2,  
    FILENAME = 'C:\test\t2dat2.ndf',  
    SIZE = 5MB,  
    MAXSIZE = 100MB,  
    FILEGROWTH = 3MB  
)  
TO FILEGROUP part2;  

ALTER DATABASE sys_bazodanowe   
ADD FILE   
(  
    NAME = part3,  
    FILENAME = 'C:\test\t3dat3.ndf',  
    SIZE = 5MB,  
    MAXSIZE = 100MB,  
    FILEGROWTH = 3MB  
)  
TO FILEGROUP part3;  

ALTER DATABASE sys_bazodanowe   
ADD FILE   
(  
    NAME = part4,  
    FILENAME = 'C:\test\t4dat4.ndf',  
    SIZE = 5MB,  
    MAXSIZE = 100MB,  
    FILEGROWTH = 3MB  
)  
TO FILEGROUP part4;  

ALTER DATABASE sys_bazodanowe
drop PARTITION FUNCTION towarPartitionfunction; 


CREATE PARTITION FUNCTION towarPartitionfunction (int)  
    AS RANGE LEFT FOR VALUES (100, 300, 500) ;  


DROP PARTITION SCHEME myPartiotion; 
CREATE PARTITION SCHEME myPartiotion  
    AS PARTITION towarPartitionfunction  
    TO (part1, part2, part3, part4) ;  

	CREATE TABLE towar (id int PRIMARY KEY, price int, towar_name VARCHAR(100))
    ON myPartiotion (id);  


   
truncate table PartitionTable
drop table PartitionTable;

   
set nocount on
declare @i int = 1;
declare @j int = (select count(*) from towar);
while @i<=@j
begin
	declare @price int = (select cena from towar where id_towaru = @i);
	declare @name varchar(100) = (select nazwa from towar where id_towaru = @i);
	insert into PartitionTable values(@i, @price, @name)
set @i=@i+1;
end

--w ktorej partycji jest 500
SELECT $PARTITION.towarPartitionfunction (6);



select * from PartitionTable;

--nr partycji i liczba elementow w partycji
SELECT $PARTITION.towarPartitionfunction(id) AS Partition,COUNT(*) AS [COUNT] FROM PartitionTable   
GROUP BY $PARTITION.towarPartitionfunction(id)  
ORDER BY Partition ;  

SELECT * FROM PartitionTable  
WHERE $PARTITION.towarPartitionfunction(id) = 2 ; --rekordy z 2 partycji  


SELECT * FROM PartitionTable  
WHERE $PARTITION.towarPartitionfunction(id) = 4 and id>500; --rekordy z 4 partycji wieksze od 3000  


SELECT *   
FROM sys.tables AS t   
JOIN sys.indexes AS i   
    ON t.[object_id] = i.[object_id]
    AND i.[type] IN (0,1)
JOIN sys.partition_schemes ps   
    ON i.data_space_id = ps.data_space_id   
WHERE t.name = 'PartitionTable';   


SELECT t.name AS TableName, i.name AS IndexName, p.partition_number, p.partition_id, i.data_space_id, f.function_id, f.type_desc, r.boundary_id, r.value AS BoundaryValue   
FROM sys.tables AS t  
JOIN sys.indexes AS i  
    ON t.object_id = i.object_id  
JOIN sys.partitions AS p  
    ON i.object_id = p.object_id AND i.index_id = p.index_id   
JOIN  sys.partition_schemes AS s   
    ON i.data_space_id = s.data_space_id  
JOIN sys.partition_functions AS f   
    ON s.function_id = f.function_id  
LEFT JOIN sys.partition_range_values AS r   
    ON f.function_id = r.function_id and r.boundary_id = p.partition_number  
WHERE t.name = 'PartitionTable' AND i.type <= 1  
ORDER BY p.partition_number;