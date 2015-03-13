<?php
// pMUD copyright (c) 2005 H. Gilliland
// Purpose: Generic script, updates an existing value in the db

// Parse URL
$t = $_GET['t'];  // table
$c = $_GET['c'];  // column
$v = $_GET['v'];  // value
$s = $_GET['s'];  // search column
$k = $_GET['k'];  // search key
$l = $_GET['l'];  // row limit

$err = mysql_connect( 'localhost','dmud','dmudpassword');
$db = mysql_select_db( 'dmuddb' );
if ( !$err ) { echo 'DBERROR'; die(); }

// Perform Query
$query = sprintf( 
 "UPDATE `" . $t . "` SET `" . $c . "`='" . $v 
. "' WHERE `" . $t . "`.`" . $s . "`='" . $k . "';" );
$result = mysql_query($query);
echo $query . "=" . $result;
?>