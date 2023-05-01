-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 01, 2023 at 01:28 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.0.28

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `project_db`
--

DELIMITER $$
--
-- Procedures
--
CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_getProducts` (IN `p_productid` INT)   BEGIN

if p_productid = 0 then
   select * from tbl_products;
else
   select * from tbl_products where productid = p_productid;

end if;


END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_login` (IN `pusername` TEXT, IN `ppassword` TEXT)   BEGIN

declare ret int;
declare stat int;
declare c_lock int;
if exists(select * from tbl_users where username = pusername and password = ppassword) THEN

	set stat = (select status from tbl_users where username = pusername and password = password);
    set c_lock = (select counterlock from tbl_users where username = pusername and password = password);
    if stat = 1 THEN
        if c_lock >= 3 THEN
            set ret = 4;
            select ret;
        ELSE
          	set ret = 1;
    		select *,ret from tbl_users where username = pusername and password = ppassword;
        end if;
    	
    else
    	set ret = 2; 
        select ret;
    end if;

ELSE

	update tbl_users set counterlock = counterlock + 1 where username = pusername;
	set ret = 3;
    
	select ret;

end if;

END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_save` (IN `p_userid` INT, IN `p_fullname` TEXT, IN `p_username` TEXT, IN `p_password` TEXT, IN `p_email` TEXT)   BEGIN

if p_userid = 0 THEN
insert into tbl_users(fullname,username,password,email,user_role,date_created,status) values(p_fullname,p_username,p_password,p_email,2,now(),1);
ELSE
update tbl_users set fullname = p_fullname,username = p_username,password = p_password,email = p_email where userid = p_userid;
end if;
END$$

CREATE DEFINER=`root`@`localhost` PROCEDURE `sp_saveUpdateProduct` (IN `p_productname` TEXT, IN `p_description` TEXT, IN `p_quantity` INT, IN `p_price` TEXT, IN `p_image` TEXT, IN `p_productid` INT)   BEGIN

	if p_productid = 0 THEN
    	insert into tbl_products(productname,description,quantity,price,image,date_inserted)
        values(p_productname,p_description,p_quantity,p_price,p_image,now());
    else
    	update tbl_products set 
        productname = p_productname,
        description = p_description,
        quantity = p_quantity,
        price = p_price,
        image = p_image
        where productid = p_productid;
       
    end if;
        

END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `tbl_products`
--

CREATE TABLE `tbl_products` (
  `productid` int(11) NOT NULL,
  `productname` text NOT NULL,
  `description` text NOT NULL,
  `quantity` int(11) NOT NULL,
  `price` text NOT NULL,
  `image` text NOT NULL,
  `date_inserted` date NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_products`
--

INSERT INTO `tbl_products` (`productid`, `productname`, `description`, `quantity`, `price`, `image`, `date_inserted`) VALUES
(5, 'test', 'test', 2, '123', 'breakie-deal-1-1.jpg', '2023-04-30'),
(6, 'we', 'we', 23, '42', 'meatball.jpg', '2023-04-30'),
(7, 'norcube', 'doyoy', 34, '123', 'nachos-supreme.png', '2023-04-30');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `userid` int(11) NOT NULL,
  `fullname` text NOT NULL,
  `username` text NOT NULL,
  `password` text NOT NULL,
  `email` text NOT NULL,
  `user_role` int(11) NOT NULL,
  `date_created` datetime NOT NULL,
  `status` int(11) NOT NULL,
  `counterlock` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`userid`, `fullname`, `username`, `password`, `email`, `user_role`, `date_created`, `status`, `counterlock`) VALUES
(27, 'admin', 'admin', '21232f297a57a5a743894a0e4a801fc3', 'admin@gmail.com', 1, '2023-05-01 16:07:47', 1, 0),
(28, 'aw', 'aw', 'b787d22d9cb06342658bf546039117bc', 'aw@gmail.com', 2, '2023-05-01 16:12:19', 1, 1),
(29, 'he', 'he', '6f96cfdfe5ccc627cadf24b41725caa4', 'he@gmail.com', 2, '2023-05-01 16:28:19', 1, 0),
(30, 'lol', 'lol', '9cdfb439c7876e703e307864c9167a15', 'lol@gmail.com', 2, '2023-05-01 17:21:12', 1, 0),
(31, 'nora', 'nora', '23f88ac14feead92f4fdf8e640507d3c', 'nora@gmail.com', 2, '2023-05-01 17:54:46', 1, 0),
(32, 'renalyn', 'renalyn', '827ccb0eea8a706c4c34a16891f84e7b', 'renalyn@gmail.com', 2, '2023-05-01 18:20:19', 1, 0);

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_products`
--
ALTER TABLE `tbl_products`
  ADD PRIMARY KEY (`productid`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`userid`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_products`
--
ALTER TABLE `tbl_products`
  MODIFY `productid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `userid` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=33;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
