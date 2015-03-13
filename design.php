<?php
// pMUD copyright (c) 2005 H. Gilliland
// Purpose: insert new item

$vnum         = $_GET['v'];
$name         = $_GET['n'];
$type         = $_GET['t'];
$value        = $_GET['va'];
$level        = $_GET['lv'];

$err = mysql_connect( 'localhost','dmud','dmudpassword');
$db = mysql_select_db( 'dmuddb' );
if ( !$err ) { echo 'DBERROR'; die(); }

// Perform Query
$query = sprintf(
 "INSERT INTO `items` ( `name` , `vnum` , `level`, `type`, `value` ) " .
  " VALUES ('" . $name .
 "', '" . $vnum . "', '" . $level .
 "', '" . $type . "', '" . $value .
 "');" );
$result = mysql_query($query);
echo $result;
?>