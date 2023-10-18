DROP DATABASE IF EXISTS biobank_dev;
DROP USER IF EXISTS 'my_user'@'%';

CREATE DATABASE biobank_dev;
CREATE USER 'my_user'@'%' IDENTIFIED BY 'my_password';
GRANT ALL PRIVILEGES ON biobank_dev.* TO 'my_user'@'%';
FLUSH PRIVILEGES;

USE biobank_dev;

-- biobanque_dev.list_projects definition
CREATE TABLE `list_projects` (
  `list_project_ID` int NOT NULL AUTO_INCREMENT,
  `project_name` varchar(255) DEFAULT NULL,
  `date_started` varchar(40) DEFAULT NULL,
  `CER_ID` varchar(255) DEFAULT NULL,
  `mask` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`list_project_ID`)
);

-- biobanque_dev.list_site definition
CREATE TABLE `list_site` (
  `center_ID` int NOT NULL AUTO_INCREMENT,
  `center_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`center_ID`)
);

-- biobanque_dev.list_pi definition
CREATE TABLE `list_pi` (
  `PI_ID` int NOT NULL AUTO_INCREMENT,
  `PI_name` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`PI_ID`)
);

-- biobanque_dev.subject_tbl definition
CREATE TABLE `subject_tbl` (
  `SDB_ID` int NOT NULL AUTO_INCREMENT,
  `active` int DEFAULT NULL,
  `lastName` varchar(255) DEFAULT NULL,
  `middleName` varchar(255) DEFAULT NULL,
  `firstName` varchar(255) DEFAULT NULL,
  `maidenName` varchar(255) DEFAULT NULL,
  `marriedName` varchar(255) DEFAULT NULL,
  `DOB` date DEFAULT NULL,
  `sex` int DEFAULT NULL,
  `RAMQ` varchar(255) DEFAULT NULL,
  `date_added` date DEFAULT NULL,
  `lastName_strip` varchar(255) DEFAULT NULL,
  `firstName_strip` varchar(255) DEFAULT NULL,
  `erroneousInfoFlag` int DEFAULT NULL,
  `erroneousInfoCmt` varchar(255) DEFAULT NULL,
  `clinicalFileScanned` int DEFAULT NULL,
  `validatedNoDuplicate` int DEFAULT NULL,
  `deceased` int DEFAULT NULL,
  `ethnicity` int DEFAULT NULL,
  `createdBy` varchar(255) DEFAULT NULL,
  `ethnicityFinal` int DEFAULT NULL,
  `ethnicitySource` varchar(255) DEFAULT NULL,
  `ethnicityDate` varchar(40) DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `phoneNumberHome` varchar(255) DEFAULT NULL,
  `phoneNumberWork` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `email` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`SDB_ID`)
);

-- biobanque_dev.projectlink_tbl definition
CREATE TABLE `projectlink_tbl` (
  `projectlink_ID` int NOT NULL AUTO_INCREMENT,
  `SDB_ID` int DEFAULT NULL,
  `project_name` int DEFAULT NULL,
  `PSSID` int DEFAULT NULL,
  `PSSIDwithMask` varchar(255) DEFAULT NULL,
  `consent_project` int DEFAULT NULL,
  `consent_bb` int DEFAULT NULL,
  `mask` varchar(255) DEFAULT NULL,
  `projectPI` int DEFAULT NULL,
  `projectGroup` int DEFAULT NULL,
  `projectSite` int DEFAULT NULL,
  `mostRecentDiagnosis` int DEFAULT NULL,
  `ROO_ID` int DEFAULT NULL,
  `PIStatus` int DEFAULT NULL,
  `toDeleteFlag` varchar(255) DEFAULT NULL,
  `comment` varchar(255) DEFAULT NULL,
  `commentConsent` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`projectlink_ID`),
  KEY `list_PIprojectLink_tbl` (`projectPI`),
  KEY `list_projectsprojectLink_tbl` (`project_name`),
  KEY `subject_tblprojectLink_tbl` (`SDB_ID`),
  CONSTRAINT `list_PIprojectLink_tbl` FOREIGN KEY (`projectPI`) REFERENCES `list_pi` (`PI_ID`),
  CONSTRAINT `list_projectsprojectLink_tbl` FOREIGN KEY (`project_name`) REFERENCES `list_projects` (`list_project_ID`),
  CONSTRAINT `subject_tblprojectLink_tbl` FOREIGN KEY (`SDB_ID`) REFERENCES `subject_tbl` (`SDB_ID`)
);

-- biobanque_dev.freezerpro_tbl definition
CREATE TABLE `freezerpro_tbl` (
  `FP_ID` int NOT NULL AUTO_INCREMENT,
  `ProjectLink_ID` int DEFAULT NULL,
  `FP_barcode` varchar(255) DEFAULT NULL,
  `FP_name` varchar(255) DEFAULT NULL,
  `FP_description` varchar(255) DEFAULT NULL,
  `FP_sampleType` varchar(255) DEFAULT NULL,
  `FP_vials` int DEFAULT NULL,
  `FP_volume` varchar(255) DEFAULT NULL,
  `FP_expiration` varchar(40) DEFAULT NULL,
  `FP_createdAt` varchar(255) DEFAULT NULL,
  `FP_RFID` varchar(255) DEFAULT NULL,
  `FP_level1` varchar(255) DEFAULT NULL,
  `FP_level2` varchar(255) DEFAULT NULL,
  `FP_level3` varchar(255) DEFAULT NULL,
  `FP_level4` varchar(255) DEFAULT NULL,
  `FP_level5` varchar(255) DEFAULT NULL,
  `FP_box` varchar(255) DEFAULT NULL,
  `FP_position` varchar(255) DEFAULT NULL,
  `FP_freezer` varchar(255) DEFAULT NULL,
  PRIMARY KEY (`FP_ID`)
);

-- VIEWS
create or replace
algorithm = UNDEFINED view `by_sample_view` as
	select
	    `fp`.`ProjectLink_ID` as `project_link_id`,
	    `pl`.`SDB_ID` as `sdb_id`,
	    `pl`.`PSSID` as `pssid`,
	    `pl`.`PSSIDwithMask` as `pssid_mask`,
	    `fp`.`FP_sampleType` as `sample_type`,
	    `fp`.`FP_barcode` as `barcode`,
	    `fp`.`FP_volume` as `volume`,
        `fp`.`FP_createdAt` as `created_at`,
	    `lp`.`project_name` as `project_name`,
	    `lpi`.`PI_name` as `pi_name`,
	    `pl`.`projectGroup` as `project_group`,
	    `ls`.`center_name` as `site_name`
	from
	    ((((`freezerpro_tbl` `fp`
	join `projectlink_tbl` `pl` on
	    ((`fp`.`ProjectLink_ID` = `pl`.`projectlink_ID`)))
	join `list_projects` `lp` on
	    ((`lp`.`list_project_ID` = `pl`.`project_name`)))
	join `list_pi` `lpi` on
	    ((`lpi`.`PI_ID` = `pl`.`projectPI`)))
	join `list_site` `ls` on
	    ((`ls`.`center_ID` = `pl`.`projectSite`)))
	where
	    (`fp`.`ProjectLink_ID` is not null)
	order by
	    `fp`.`ProjectLink_ID`;

source ./data_sources/biobank_dev/insert_freezerpro_tbl.sql;
source ./data_sources/biobank_dev/insert_list_pi_tbl.sql;
source ./data_sources/biobank_dev/insert_list_project_tbl.sql;
source ./data_sources/biobank_dev/insert_list_site_tbl.sql;
source ./data_sources/biobank_dev/insert_subject_tbl.sql;
source ./data_sources/biobank_dev/insert_projectlink_tbl.sql;
