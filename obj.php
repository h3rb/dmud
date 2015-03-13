<?php
// pMUD copyright (c) 2005 H. Gilliland
// Purpose: return obj data

$v = $_GET['v'];

$err = mysql_connect( 'localhost','dmud','dmudpassword');
$db = mysql_select_db( 'dmuddb' );
if ( !$err ) { echo 'DBERROR'; die(); }

// Perform Query
$query = sprintf( 
 "SELECT * FROM `items` WHERE `items`.`vnum`='" . $v . "' LIMIT 1" );
$result = mysql_query($query);

// Check result
// This shows the actual query sent to MySQL, and the error.
// Useful for debugging.

if ($result) { // Use result to display record
   $found=0;
   while ($row = mysql_fetch_assoc($result)) {
      $found=1;
      echo $row['vnum']   . "|" .
           $row['name']   . "|" .
           $row['type']   . "|" .
           $row['value']  . "|" .
           $row['level']  . "|";
     }
   if ( $found == 0 ) echo "NEW";
} else echo "DBERROR";
?>    