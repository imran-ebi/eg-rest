-- MySQL dump 10.13  Distrib 5.1.61, for redhat-linux-gnu (x86_64)
--
-- Host: mysql-eg-devel-1.ebi.ac.uk    Database: test_ensembl_compara_bacteria_22_75
-- ------------------------------------------------------
-- Server version	5.5.36-log

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `genomic_align`
--

DROP TABLE IF EXISTS `genomic_align`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `genomic_align` (
  `genomic_align_id` bigint(20) unsigned NOT NULL AUTO_INCREMENT,
  `genomic_align_block_id` bigint(20) unsigned NOT NULL,
  `method_link_species_set_id` int(10) unsigned NOT NULL DEFAULT '0',
  `dnafrag_id` bigint(20) unsigned NOT NULL DEFAULT '0',
  `dnafrag_start` int(10) NOT NULL DEFAULT '0',
  `dnafrag_end` int(10) NOT NULL DEFAULT '0',
  `dnafrag_strand` tinyint(4) NOT NULL DEFAULT '0',
  `cigar_line` mediumtext,
  `visible` tinyint(2) unsigned NOT NULL DEFAULT '1',
  `node_id` bigint(20) unsigned DEFAULT NULL,
  PRIMARY KEY (`genomic_align_id`),
  KEY `genomic_align_block_id` (`genomic_align_block_id`),
  KEY `method_link_species_set_id` (`method_link_species_set_id`),
  KEY `dnafrag` (`dnafrag_id`,`method_link_species_set_id`,`dnafrag_start`,`dnafrag_end`),
  KEY `node_id` (`node_id`)
) ENGINE=MyISAM DEFAULT CHARSET=latin1 MAX_ROWS=1000000000 AVG_ROW_LENGTH=60 CHECKSUM=1;
/*!40101 SET character_set_client = @saved_cs_client */;

/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2014-05-22 14:39:54