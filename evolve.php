<?php
// pMUD copyright (c) 2005 H. Gilliland
// Purpose: evolve a new creature

$vnum       = $_GET['v'];
$name       = $_GET['n'];
$hp         = $_GET['hp'];
$xp         = $_GET['xp'];
$level      = $_GET['lv'];
$wanderer   = $_GET['w'];
$aggressive = $_GET['a'];

$err = mysql_connect( 'localhost','dmud','dmudpassword');
$db = mysql_select_db( 'dmuddb' );
if ( !$err ) { echo 'DBERROR'; die(); }

// Perform Query
$query = sprintf(
 "INSERT INTO `creatures` ( `name`, `vnum`, `level`, `aggressive`, `wander` )" .
 " VALUES ('" . $name .
 "', '" . $vnum . "', '" . $level .
 "', '" . $aggressive . "', '" . $wander .
 "');" );
$result = mysql_query($query);
echo $result;
?>