-- phpMyAdmin SQL Dump
-- version 3.5.2.2
-- http://www.phpmyadmin.net
--
-- Host: 127.0.0.1
-- Generation Time: Mar 30, 2014 at 08:15 PM
-- Server version: 5.5.27
-- PHP Version: 5.4.7

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `medomai`
--

-- --------------------------------------------------------

--
-- Table structure for table `categories`
--

CREATE TABLE IF NOT EXISTS `categories` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `category` varchar(75) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=10 ;

--
-- Dumping data for table `categories`
--

INSERT INTO `categories` (`id`, `category`) VALUES
(1, 'animemanga'),
(2, 'science'),
(3, 'trivia'),
(4, 'videogames'),
(5, 'sports'),
(6, 'logos'),
(7, 'music'),
(8, 'movies'),
(9, 'all');

-- --------------------------------------------------------

--
-- Table structure for table `choices`
--

CREATE TABLE IF NOT EXISTS `choices` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `choice` varchar(75) DEFAULT NULL,
  `category` int(11) DEFAULT NULL,
  `type` int(11) DEFAULT NULL,
  `universe` int(11) DEFAULT NULL,
  `gender` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `choices_categories_FK` (`category`),
  KEY `choices_universes_FK` (`universe`),
  KEY `choices_types_FK` (`type`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=23 ;

--
-- Dumping data for table `choices`
--

INSERT INTO `choices` (`id`, `choice`, `category`, `type`, `universe`, `gender`) VALUES
(1, 'Kurama', 1, 1, 1, 1),
(2, 'Naruto', 1, 1, 1, 1),
(3, 'Sasuke', 1, 1, 1, 1),
(4, 'Killer Bee', 1, 1, 1, 1),
(5, 'Minato', 1, 1, 1, 1),
(6, 'Kushina', 1, 1, 1, 2),
(7, 'Orochimaru', 1, 1, 1, 1),
(8, 'Shanks', 1, 1, 2, 1),
(9, 'Garp', 1, 1, 2, 1),
(10, 'Gold Roger', 1, 1, 2, 1),
(11, 'Nami', 1, 1, 2, 2),
(12, 'Sanji', 1, 1, 2, 1),
(13, 'Ace', 1, 1, 2, 1),
(14, 'Robert Downey Jr.', 8, 2, 3, 1),
(15, 'Patrick Stewart', 8, 2, 3, 1),
(16, 'Ian McKellen', 8, 2, 3, 1),
(17, 'Hugh Jackman', 8, 2, 3, 1),
(18, 'Brad Pitt', 8, 2, 3, 1),
(19, 'Edward Norton', 8, 2, 3, 1),
(20, 'Samuel Jackson', 8, 2, 3, 1),
(21, 'True', 9, 3, 4, 3),
(22, 'False', 9, 3, 4, 3);

-- --------------------------------------------------------

--
-- Table structure for table `genders`
--

CREATE TABLE IF NOT EXISTS `genders` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `gender` varchar(30) NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `genders`
--

INSERT INTO `genders` (`id`, `gender`) VALUES
(1, 'male'),
(2, 'female'),
(3, 'N/A');

-- --------------------------------------------------------

--
-- Table structure for table `questions`
--

CREATE TABLE IF NOT EXISTS `questions` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `question` varchar(255) NOT NULL,
  `answer` int(11) NOT NULL,
  `category` int(11) NOT NULL,
  `type` int(11) NOT NULL,
  `universe` int(11) NOT NULL,
  `gender` int(11) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `questions_choices_answer_FK` (`answer`),
  KEY `questions_category_FK` (`category`),
  KEY `questions_type_FK` (`type`),
  KEY `questions_universe_FK` (`universe`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=7 ;

--
-- Dumping data for table `questions`
--

INSERT INTO `questions` (`id`, `question`, `answer`, `category`, `type`, `universe`, `gender`) VALUES
(1, 'In Naruto, what is Kyuubi''s name?', 1, 1, 1, 1, 1),
(2, 'In One Piece, who gave Luffy his straw hat?', 8, 1, 1, 2, 1),
(3, 'Who has the role of Tony Stark in Iron Man(2008)', 14, 8, 2, 3, 1),
(4, 'Who has the role of Nick Fury in The Avengers(2012)', 20, 8, 2, 3, 1),
(5, 'Tite Kubo is the author of Hunter X Hunter.', 22, 1, 3, 3, 3),
(6, 'Peter Jackson directed Braindead', 21, 8, 3, 3, 3);

-- --------------------------------------------------------

--
-- Table structure for table `types`
--

CREATE TABLE IF NOT EXISTS `types` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `typeName` varchar(75) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=4 ;

--
-- Dumping data for table `types`
--

INSERT INTO `types` (`id`, `typeName`) VALUES
(1, 'name'),
(2, 'actor'),
(3, 'truefalse');

-- --------------------------------------------------------

--
-- Table structure for table `universes`
--

CREATE TABLE IF NOT EXISTS `universes` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `universeName` varchar(75) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=5 ;

--
-- Dumping data for table `universes`
--

INSERT INTO `universes` (`id`, `universeName`) VALUES
(1, 'naruto'),
(2, 'onepiece'),
(3, 'realworld'),
(4, 'all');

--
-- Constraints for dumped tables
--

--
-- Constraints for table `choices`
--
ALTER TABLE `choices`
  ADD CONSTRAINT `choices_categories_FK` FOREIGN KEY (`category`) REFERENCES `categories` (`id`),
  ADD CONSTRAINT `choices_types_FK` FOREIGN KEY (`type`) REFERENCES `types` (`id`),
  ADD CONSTRAINT `choices_universes_FK` FOREIGN KEY (`universe`) REFERENCES `universes` (`id`);

--
-- Constraints for table `questions`
--
ALTER TABLE `questions`
  ADD CONSTRAINT `questions_category_FK` FOREIGN KEY (`category`) REFERENCES `categories` (`id`),
  ADD CONSTRAINT `questions_choices_answer_FK` FOREIGN KEY (`answer`) REFERENCES `choices` (`id`),
  ADD CONSTRAINT `questions_type_FK` FOREIGN KEY (`type`) REFERENCES `types` (`id`),
  ADD CONSTRAINT `questions_universe_FK` FOREIGN KEY (`universe`) REFERENCES `universes` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
