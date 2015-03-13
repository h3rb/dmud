<?php
// dMUD copyright (c) 2005 H. Gilliland
// mySQL database genesis script

// open the connection

$conn = mysql_connect("localhost", "dmud", "dmudpassword");

// create database 
$create_success = mysql_create_db("dmuddb");
if($create_success)
echo("<b><font color=\"blue\">create database: success!</font></b><br>");

// pick the database to use
mysql_select_db("dmuddb",$conn);

echo "1a) create the player table: ";
$sql = "CREATE TABLE players (id int not null primary key auto_increment,
name varchar (75),
password varchar (75),
wizard int not null,
gender int not null,
discipline enum('mage','cleric','warrior','thief'),
strength int not null,
intelligence int not null,
wisdom int not null,
dexterity int not null,
constitution int not null,
charisma int not null,
experience int not null,
level int not null,
gold int not null,
hp int not null,
mana int not null,
damroll int not null,
hitroll int not null,
ac int not null,
location int not null )";
$result = mysql_query($sql, $conn) or die(mysql_error()); 
if ($result) echo "success!<br>";
else echo "fail: " . $result . "<br>";

echo "1b) create the administrative player: ";
$sql = "INSERT INTO `players` 
( `name`,
`password`,
`wizard`,
`gender`,
`discipline`,
`strength`,
`intelligence`,
`wisdom`,
`dexterity`,
`constitution`,
`charisma`,
`experience`,
`level`,
`gold`,
`hp`,
`mana`,
`damroll`,
`hitroll`,
`ac`,
`location` ) VALUES 
('Admin', 
'Password', 
'1', '0', 
'mage', 
'18', '18', '18', '18', '18', '18', 
'1000000', '1000000', '1000000', '1000000', '1000000', 
'30', '30', '100', '1');";
$result = mysql_query($sql, $conn) or die(mysql_error());
if ($result) echo "success!<br>";
else echo "fail: " . $result . "<br>";

echo "2) create the creatures table: ";
$sql = 'CREATE TABLE `creatures` ( `name` VARCHAR( 75 ) NOT NULL ,'
. ' `level` INT( 1 ) NOT NULL ,'
. ' `aggressive` INT( 0 ) NOT NULL ,'
. ' `wanderer` INT( 1 ) NOT NULL ,'
. ' `vnum` INT NOT NULL AUTO_INCREMENT ,'
. ' PRIMARY KEY ( `vnum` ) );';
$result = mysql_query($sql, $conn) or die(mysql_error());
if ($result) echo "success!<br>";
else echo "fail: " . $result . "<br>";

echo "3) create the items table: ";
$sql = 'CREATE TABLE `items` ( `name` VARCHAR( 75 ) NOT NULL ,'
. ' `level` INT( 1 ) NOT NULL ,'
. ' `type` INT( 0 ) NOT NULL ,'
. ' `value` INT( 1 ) NOT NULL ,'
. ' `vnum` INT NOT NULL AUTO_INCREMENT ,'
. ' PRIMARY KEY ( `vnum` ) );';
$result = mysql_query($sql, $conn) or die(mysql_error());
if ($result) echo "success!<br>";
else echo "fail: " . $result . "<br>";

echo "4a) create the scene table: ";
$sql = 'CREATE TABLE `scenes` ( `title` VARCHAR( 75 ) NOT NULL ,'
. '`description` LONGTEXT NOT NULL ,'
. '`north` INT NOT NULL ,'
. '`south` INT NOT NULL ,'
. '`east` INT NOT NULL ,'
. '`west` INT NOT NULL ,'
. '`up` INT NOT NULL ,'
. '`down` INT NOT NULL ,'
. '`type` ENUM( \'enclosed\', \'underwater\', \'air\', \'exterior\' ) NOT NULL,'
. '`location` INT NOT NULL AUTO_INCREMENT,'
. ' PRIMARY KEY ( `location` ) );';
$result = mysql_query($sql, $conn) or die(mysql_error());
if ($result) echo "success!<br>";
else echo "fail: " . $result . "<br>";

echo "4b) create starting scene: ";
$sql = 'INSERT INTO `scenes` 
( `location` , 
`title` , 
`description` , 
`north` , 
`south` , 
`east` , 
`west` , 
`up`, 
`down`, 
`type` ) VALUES 
( \'1\', 
\'The Garden\', 
\'You are standing in a garden next to a large apple tree. You hear the sound of birds chirping a pleasant song.\', 
\'0\', \'0\', \'0\', \'0\', \'0\', \'0\', \'enclosed\' );';
$result = mysql_query($sql, $conn) or die(mysql_error());
if ($result) echo "success!<br>";
else echo "fail: " . $result . "<br>";

// close the connection to the db
mysql_close();
?>