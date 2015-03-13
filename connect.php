<?php
// pMUD copyright (c) 2005 H. Gilliland
// Purpose: Connects two scenes

$loc = $_GET['loc'];
$dir = $_GET['dir'];

$err = mysql_connect( 'localhost','dmud','dmudpassword');
$db = mysql_select_db( 'dmuddb' );
if ( !$err ) { echo 'DBERROR'; die(); }

// Perform Query
$query = sprintf(
 "SELECT * FROM `scenes` WHERE `scenes`.`location`='" . $loc . "' LIMIT 1" );
$result = mysql_query($query);

// Check result
if ($result) { // Use result to display record
 $found=0;
 while ($row = mysql_fetch_assoc($result)) {
  $found=1;
  echo $row[$dir];
 }
 if ( $found == 0 ) echo "NONE";
} else echo "DBERROR";
?>