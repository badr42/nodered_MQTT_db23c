CREATE USER C##nodered IDENTIFIED BY Password123;
GRANT CREATE SESSION TO C##nodered;
GRANT CREATE TABLE TO C##nodered;
CREATE TABLE C##nodered.nodered (col1 varchar2(500),col2 varchar2(500));
exit;